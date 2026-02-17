//
//  TrendsView.swift
//  Trends
//
//  Created by Ihor Myronishyn on 14.02.2026.
//

import SwiftUI
import Factory
import Entities
import SwiftData
import Components
import Persistence

public struct TrendsView: View {
    
    // MARK: - Properties
    
    @InjectedObservable(\.quickLookManager) var quickLookManager
    
    @State private var viewModel = TrendsViewModel()
    
    // MARK: - Init
    
    public init() {
        // Nothing.
    }
    
    // MARK: - Body
    
    public var body: some View {
        NavigationStack {
            container
                .navigationTitle("Trends")
                .navigationBarTitleDisplayMode(.large)
        } //: NavigationStack
        .quickLook(using: quickLookManager)
        .task {
            if viewModel.state.isReloadable {
                await viewModel.loadPosts()
            }
        }
    }
    
    // MARK: - Container
    
    @ViewBuilder
    private var container: some View {
        switch viewModel.state {
        case .initial, .loading, .loaded:
            if viewModel.posts.isEmpty {
                loader
            } else {
                list
            }
        case .failed(let error):
            unavailable(error)
        }
    }
    
    // MARK: - Loader
    
    private var loader: some View {
        ProgressView()
    }
    
    // MARK: - Unavailable
    
    private func unavailable(_ error: Error) -> some View {
        ErrorContentUnavailableView(error: error)
    }
    
    // MARK: - List
    
    private var list: some View {
        PostList(posts: viewModel.posts) {
            Task {
                await viewModel.loadPosts()
            }
        } //: PostList
    }
}

// MARK: - Preview

#Preview {
    TrendsView()
}
