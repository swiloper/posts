//
//  PostAccountView.swift
//  Components
//
//  Created by Ihor Myronishyn on 16.02.2026.
//

import SwiftUI
import Entities

struct PostAccountView: View {
    
    // MARK: - Properties
    
    let post: Post
    
    // MARK: - Body
    
    var body: some View {
        HStack(alignment: .top) {
            container
            info
        } //: HStack
        .frame(height: 44)
    }
    
    // MARK: - Container
    
    private var container: some View {
        HStack {
            avatar
            label
        } //: HStack
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Avatar
    
    private var avatar: some View {
        RemoteImageView(path: post.account.avatar)
            .aspectRatio(1, contentMode: .fit)
            .clipShape(.rect(cornerRadius: 8))
    }
    
    // MARK: - Label
    
    private var label: some View {
        VStack(alignment: .leading) {
            Text(post.account.displayName)
                .font(.headline)
                
            Text("@\(post.account.acct)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        } //: VStack
        .lineLimit(1)
    }
    
    // MARK: - Info
    
    private var info: some View {
        HStack(spacing: 2) {
            Text(post.relativeCreatedAt)
            
            if post.editedAt != nil {
                Text("*")
            }
        } //: HStack
        .foregroundStyle(.secondary)
    }
}

// MARK: - Preview

#Preview {
    
}
