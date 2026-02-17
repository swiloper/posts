//
//  FetchPostRepository.swift
//  Interfaces
//
//  Created by Ihor Myronishyn on 13.02.2026.
//

import Entities
import Foundation

@MainActor
public protocol FetchPostRepository: Sendable {
    func fetchCachedPosts() -> PaginatedResponse<Post>
    func fetchRemotePosts(limit: Int, offset: Int) async throws -> PaginatedResponse<Post>
}
