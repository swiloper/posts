//
//  FetchPostsUseCase.swift
//  UseCases
//
//  Created by Ihor Myronishyn on 13.02.2026.
//

import Entities
import Interfaces
import Foundation

public final class FetchPostsUseCase: Sendable {
    
    // MARK: - Properties
    
    private let repository: FetchPostRepository
    
    // MARK: - Init
    
    public init(repository: FetchPostRepository) {
        self.repository = repository
    }
    
    // MARK: - Execute
    
    public func execute(limit: Int = 20, offset: Int = .zero) async throws -> PaginatedResponse<Post> {
        try await repository.fetchRemotePosts(limit: limit, offset: offset)
    }
    
    // MARK: - Cached
    
    @MainActor
    public func cached() -> PaginatedResponse<Post> {
        repository.fetchCachedPosts()
    }
}
