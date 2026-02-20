//
//  PostActionsView.swift
//  Components
//
//  Created by Ihor Myronishyn on 16.02.2026.
//

import SwiftUI
import Entities
import UniformTypeIdentifiers

struct PostActionsView: View {
    
    // MARK: - Properties
    
    let post: Post
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            replies
            Spacer(minLength: .zero)
            reblogs
            Spacer(minLength: .zero)
            favourites
            Spacer(minLength: .zero)
            more
        } //: HStack
        .foregroundStyle(.secondary)
    }
    
    // MARK: - Label
    
    private func label(title: String, systemImage: String, rotationEffect: Angle = .zero) -> some View {
        HStack(spacing: 4) {
            Image(systemName: systemImage)
                .rotationEffect(rotationEffect)
            
            Text(title)
        } //: HStack
    }
    
    // MARK: - Replies
    
    private var replies: some View {
        label(title: "\(post.repliesCount)", systemImage: "arrow.turn.up.left")
    }
    
    // MARK: - Reblogs
    
    private var reblogs: some View {
        label(title: "\(post.reblogsCount)", systemImage: "arrow.2.squarepath", rotationEffect: .radians(.pi / 2))
    }
    
    // MARK: - Favourites
    
    private var favourites: some View {
        label(title: "\(post.favouritesCount)", systemImage: "star")
    }
    
    // MARK: - More
    
    private var more: some View {
        Menu {
            let link = post.url ?? post.uri
            copy(link)
            share(link)
        } label: {
            Image(systemName: "ellipsis")
                .imageScale(.large)
        } //: Menu
        .buttonStyle(.plain)
    }
    
    // MARK: - Copy
    
    private func copy(_ link: String) -> some View {
        Button("Copy", systemImage: "document.on.document") {
            UIPasteboard.general.string = link
        } //: Button
    }
    
    // MARK: - Share
    
    @ViewBuilder
    private func share(_ link: String) -> some View {
        if let url = URL(string: link) {
            ShareLink(item: url) {
                Label("Share", systemImage: "square.and.arrow.up")
            } //: ShareLink
        }
    }
}

// MARK: - Preview

#Preview {
    PostActionsView(post: .preview)
}
