//
//  TrendsViewModel.swift
//  Trends
//
//  Created by Ihor Myronishyn on 14.02.2026.
//

import Data
import Entities
import UseCases
import Utilities
import Foundation

@MainActor
@Observable
final class TrendsViewModel {
    
    // MARK: - Properties
    
    private(set) var posts: [Post] = []
    private(set) var state: DataLoadingState<[Post]> = .initial
    
    private var offset: Int? = .zero
    
    private let fetchPostsUseCase: FetchPostsUseCase
    
    // MARK: - Init
    
    init(fetchPostsUseCase: FetchPostsUseCase = FetchPostsUseCase(repository: TrendsPostsRepository())) {
        self.fetchPostsUseCase = fetchPostsUseCase
        loadCache()
    }
    
    // MARK: - Cache
    
    private func loadCache() {
        let cachedPostsResponse = fetchPostsUseCase.cached()
        
        if !cachedPostsResponse.items.isEmpty {
            posts = cachedPostsResponse.items
            state = .loaded(posts)
            offset = cachedPostsResponse.offset
        }
    }
    
    // MARK: - Load
    
    func loadPosts() async {
        guard state != .loading, let offset else { return }
        
        state = .loading
        
        do {
            let response = try await fetchPostsUseCase.execute(offset: offset)
            posts += response.items
            state = .loaded(posts)
            self.offset = response.offset
        } catch {
            state = .failed(error)
        }
    }
}
