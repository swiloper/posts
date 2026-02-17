//
//  FileDownloader.swift
//  Files
//
//  Created by Ihor Myronishyn on 17.02.2026.
//

import Foundation

public protocol FileDownloader: Actor {
    func file(for remoteURL: URL) async throws -> URL
}
