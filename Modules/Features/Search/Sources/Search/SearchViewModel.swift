//
//  SearchViewModel.swift
//  Search
//
//  Created by Ihor Myronishyn on 14.02.2026.
//

import Data
import Combine
import Entities
import UseCases
import Utilities
import Alamofire
import Foundation

@MainActor
@Observable
final class SearchViewModel {
    
    // MARK: - Properties
    
    var keyword: String = ""
    
    private(set) var lastQuery: String = ""
    private(set) var state: DataLoadingState<[Post]> = .initial
    
    private let searchPostsUseCase: SearchPostsUseCase
    
    // MARK: - Init
    
    init(searchPostsUseCase: SearchPostsUseCase = SearchPostsUseCase(repository: SearchPostsRemoteRepository())) {
        self.searchPostsUseCase = searchPostsUseCase
    }
    
    // MARK: - Debounce

    func debounce() async {
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        if keyword.isEmpty {
            reset()
        } else {
            await search()
        }
    }
    
    // MARK: - Search
    
    func search() async {
        guard !keyword.isEmpty, state != .loading else { return }
        
        guard !Task.isCancelled else { return }
        
        state = .loading
        
        do {
            let results = try await searchPostsUseCase.execute(query: keyword)
            state = .loaded(results)
            lastQuery = keyword
        } catch {
            if let afError = error.asAFError, case .explicitlyCancelled = afError {
                state = .initial
            } else {
                state = .failed(error)
            }
        }
    }
    
    // MARK: - Reset
    
    private func reset() {
        lastQuery = ""
        state = .initial
    }
}
