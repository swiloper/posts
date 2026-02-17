//
//  PostList.swift
//  Components
//
//  Created by Ihor Myronishyn on 15.02.2026.
//

import SwiftUI
import Entities

public struct PostList: View {
    
    // MARK: - Properties
    
    private let posts: [Post]
    private let onPagination: (() -> Void)?
    
    // MARK: - Init
    
    public init(posts: [Post], onPagination: (() -> Void)? = nil) {
        self.posts = posts
        self.onPagination = onPagination
    }
    
    // MARK: - Body
    
    public var body: some View {
        List {
            ForEach(posts) { post in
                Section {
                    PostView(post: post)
                } //: Section
                .listSectionSpacing(12)
                .onAppear {
                    if post == posts.last, let onPagination {
                        onPagination()
                    }
                }
            } //: ForEach
        } //: List
        .scrollIndicators(.hidden)
    }
}

// MARK: - Preview

#Preview {
    PostList(posts: []) {
        // Nothing.
    } //: PostList
}
