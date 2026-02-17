//
//  PostView.swift
//  Trends
//
//  Created by Ihor Myronishyn on 14.02.2026.
//

import SwiftUI
import Entities

public struct PostView: View {
    
    // MARK: - Properties
    
    private let post: Post
    
    // MARK: - Init
    
    public init(post: Post) {
        self.post = post
    }

    // MARK: - Body
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            account
            content
            attachments
            actions
        } //: VStack
    }
    
    // MARK: - Account
    
    private var account: some View {
        PostAccountView(post: post)
    }
    
    // MARK: - Content
    
    @ViewBuilder
    private var content: some View {
        if !post.content.isEmpty {
            PostTextContentView(post: post)
        }
    }
    
    // MARK: - Attachments
    
    private var attachments: some View {
        MediaAttachmentsView(attachments: post.mediaAttachments)
    }
    
    // MARK: - Actions
    
    private var actions: some View {
        PostActionsView(post: post)
    }
}

#Preview {
    
}
