//
//  SearchView.swift
//  Search
//
//  Created by Ihor Myronishyn on 14.02.2026.
//

import SwiftUI
import Entities
import Components

public struct SearchView: View {
    
    // MARK: - Properties
    
    @State private var viewModel = SearchViewModel()
    
    // MARK: - Init
    
    public init() {
        // Nothing.
    }
    
    // MARK: - Body
    
    public var body: some View {
        NavigationStack {
            container
                .navigationTitle("Search")
                .navigationBarTitleDisplayMode(.large)
                .searchable(text: $viewModel.keyword)
        } //: NavigationStack
        .task(id: viewModel.keyword) {
            await viewModel.debounce()
        }
    }
    
    // MARK: - Container
    
    @ViewBuilder
    private var container: some View {
        switch viewModel.state {
        case .initial:
            prompt
        case .loading:
            loader
        case .failed(let error):
            unavailable(error)
        case .loaded(let results):
            content(for: results)
        }
    }
    
    // MARK: - Prompt
    
    private var prompt: some View {
        ContentUnavailableView("Post Search", systemImage: "magnifyingglass", description: Text("Type a post title to explore details."))
    }
    
    // MARK: - Loader
    
    private var loader: some View {
        ProgressView()
    }
    
    // MARK: - Unavailable
    
    private func unavailable(_ error: Error) -> some View {
        ErrorContentUnavailableView(error: error)
    }
    
    // MARK: - Content
    
    @ViewBuilder
    private func content(for results: [Post]) -> some View {
        if !viewModel.lastQuery.isEmpty {
            if results.isEmpty {
                empty
            } else {
                list(for: results)
            }
        }
    }
    
    // MARK: - Empty
    
    private var empty: some View {
        ContentUnavailableView.search(text: viewModel.lastQuery)
    }
    
    // MARK: - List
    
    private func list(for results: [Post]) -> some View {
        PostList(posts: results)
            .scrollDismissesKeyboard(.immediately)
    }
}

// MARK: - Preview

#Preview {
    SearchView()
}
