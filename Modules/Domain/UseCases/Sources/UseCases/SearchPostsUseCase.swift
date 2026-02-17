//
//  SearchPostsUseCase.swift
//  UseCases
//
//  Created by Ihor Myronishyn on 14.02.2026.
//

import Entities
import Interfaces
import Foundation

public final class SearchPostsUseCase: Sendable {
    
    // MARK: - Properties
    
    private let repository: SearchPostRepository
    
    // MARK: - Init
    
    public init(repository: SearchPostRepository) {
        self.repository = repository
    }
    
    // MARK: - Execute
    
    public func execute(query: String, limit: Int = 100) async throws -> [Post] {
        try await repository.searchPosts(query: query, limit: limit)
    }
}
