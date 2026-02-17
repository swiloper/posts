//
//  QuickLookManager.swift
//  Files
//
//  Created by Ihor Myronishyn on 15.02.2026.
//

import SwiftUI
import Factory
import Utilities

public extension Container {
    @MainActor
    var quickLookManager: Factory<QuickLookManager> {
        self { @MainActor in
            if let cachingFileDownloader = try? CachingFileDownloader() {
                QuickLookManager(downloader: cachingFileDownloader)
            } else {
                QuickLookManager(downloader: TemporaryFileDownloader())
            }
        }.singleton
    }
}

@MainActor
@Observable
public final class QuickLookManager {
    
    // MARK: - Properties

    public internal(set) var selectedLocalFileURL: URL?
    public private(set) var state: DataLoadingState<[URL]> = .initial

    public var error: Error? {
        if case .failed(let error) = state { return error }
        return nil
    }

    @ObservationIgnored
    private var loadTask: Task<Void, Never>?
    @ObservationIgnored
    private let downloader: FileDownloader
    
    // MARK: - Init

    public init(downloader: FileDownloader) {
        self.downloader = downloader
    }

    // MARK: - Present

    public func present(selectedRemoteFileURL: URL, in remoteFilesURLs: [URL]) {
        guard !remoteFilesURLs.isEmpty else {
            state = .loaded([])
            selectedLocalFileURL = nil
            return
        }

        loadTask?.cancel()
        loadTask = Task {
            await load(selectedRemoteFileURL: selectedRemoteFileURL, remoteFilesURLs: remoteFilesURLs)
        }
    }
    
    // MARK: - Dismiss

    public func dismiss() {
        loadTask?.cancel()
        loadTask = nil
        state = .initial
        selectedLocalFileURL = nil
    }

    // MARK: - Load

    private func load(selectedRemoteFileURL: URL, remoteFilesURLs: [URL]) async {
        state = .loading

        do {
            let localFilesURLs = try await download(remoteFilesURLs)
            guard !Task.isCancelled else { return }

            state = .loaded(localFilesURLs)
            selectedLocalFileURL = select(
                selectedRemoteFileURL,
                in: remoteFilesURLs,
                localFilesURLs: localFilesURLs
            )
        } catch is CancellationError {
            return
        } catch {
            state = .failed(error)
        }
    }
    
    // MARK: - Download

    private func download(_ remoteFilesURLs: [URL]) async throws -> [URL] {
        try await withThrowingTaskGroup(of: (Int, URL).self) { group in
            for (index, url) in remoteFilesURLs.enumerated() {
                group.addTask { [downloader] in
                    let localFileURL = try await downloader.file(for: url)
                    return (index, localFileURL)
                }
            }

            var results = Array<URL?>(repeating: nil, count: remoteFilesURLs.count)
            
            for try await (index, localFileURL) in group {
                results[index] = localFileURL
            }
            
            return results.compactMap({ $0 })
        }
    }
    
    // MARK: - Select

    /// Maps the originally selected remote URL to its downloaded local counterpart.
    private func select(
        _ url: URL,
        in remoteFilesURLs: [URL],
        localFilesURLs: [URL]
    ) -> URL? {
        if let index = remoteFilesURLs.firstIndex(of: url), index < localFilesURLs.count {
            return localFilesURLs[index]
        }
        
        return localFilesURLs.first
    }
}
