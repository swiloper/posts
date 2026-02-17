//
//  CachingFileDownloader.swift
//  Files
//
//  Created by Ihor Myronishyn on 15.02.2026.
//

import Utilities
import Foundation

public actor CachingFileDownloader: FileDownloader {
    
    // MARK: - Properties

    private let fileManager: FileManager
    private let cacheDirectory: URL
    private let sizeLimit: UInt64
    private var tasks: [URL: Task<URL, Error>] = [:]
    
    // MARK: - Init

    public init(
        fileManager: FileManager = .default,
        cacheDirectoryName: String = String(describing: CachingFileDownloader.self),
        sizeLimit: UInt64 = 500 * 1024 * 1024 // 500 MB.
    ) throws {
        self.fileManager = fileManager
        self.sizeLimit = sizeLimit

        guard let baseURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            throw CocoaError(.fileNoSuchFile)
        }

        let directory = baseURL.appendingPathComponent(cacheDirectoryName, isDirectory: true)
        try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
        self.cacheDirectory = directory
    }
    
    // MARK: - File

    public func file(for remoteURL: URL) async throws -> URL {
        if let existing = tasks[remoteURL] {
            return try await existing.value
        }

        let task = Task<URL, Error> {
            defer { tasks[remoteURL] = nil }
            return try await download(from: remoteURL)
        }
        
        tasks[remoteURL] = task
        return try await task.value
    }

    // MARK: - Download

    private func download(from remoteFileURL: URL) async throws -> URL {
        let localFileURL = remoteFileURL.localFileURL(in: cacheDirectory)

        if fileManager.fileExists(atPath: localFileURL.path) {
            try fileManager.setAttributes(
                [.modificationDate: Date()],
                ofItemAtPath: localFileURL.path
            )
            
            return localFileURL
        }

        let data = try await remoteFileURL.downloadData()
        
        try fileManager.createDirectory(
            at: localFileURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        
        try data.write(to: localFileURL, options: .atomic)
        
        trimCacheSizeIfNeeded()
        
        return localFileURL
    }
    
    // MARK: - Trim

    /// Removes the oldest hash directories with cached items until total size is within `sizeLimit`.
    private func trimCacheSizeIfNeeded() {
        do {
            let hashDirectories = try fileManager.contentsOfDirectory(
                at: cacheDirectory,
                includingPropertiesForKeys: nil,
                options: .skipsHiddenFiles
            )

            var totalSize: UInt64 = .zero
            let entries: [(url: URL, size: UInt64, date: Date)] = try hashDirectories.compactMap { directory in
                let files = try fileManager.contentsOfDirectory(
                    at: directory,
                    includingPropertiesForKeys: [.fileSizeKey, .contentModificationDateKey],
                    options: .skipsHiddenFiles
                )

                guard let file = files.first else { return nil }

                let values = try file.resourceValues(forKeys: [.fileSizeKey, .contentModificationDateKey])
                let size = UInt64(values.fileSize ?? .zero)
                totalSize += size
                return (directory, size, values.contentModificationDate ?? .distantPast)
            }

            guard totalSize > sizeLimit else { return }

            for entry in entries.sorted(by: { $0.date < $1.date }) {
                try? fileManager.removeItem(at: entry.url)
                totalSize -= entry.size
                if totalSize <= sizeLimit { break }
            }
        } catch {
            debugPrint(error)
        }
    }
}
