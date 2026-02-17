//
//  TemporaryFileDownloader.swift
//  Files
//
//  Created by Ihor Myronishyn on 17.02.2026.
//

import Foundation

public actor TemporaryFileDownloader: FileDownloader {
    
    // MARK: - Properties

    private let fileManager: FileManager
    private var tasks: [URL: Task<URL, Error>] = [:]
    
    // MARK: - Init

    public init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
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
        let localFileURL = remoteFileURL.localFileURL(in: fileManager.temporaryDirectory)

        guard !fileManager.fileExists(atPath: localFileURL.path) else {
            return localFileURL
        }

        let data = try await remoteFileURL.downloadData()
        
        try fileManager.createDirectory(
            at: localFileURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        
        try data.write(to: localFileURL, options: .atomic)
        
        return localFileURL
    }
}
