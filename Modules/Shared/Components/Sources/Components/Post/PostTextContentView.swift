//
//  PostTextContentView.swift
//  Components
//
//  Created by Ihor Myronishyn on 16.02.2026.
//

import Demark
import SwiftUI
import Entities

struct PostTextContentView: View {
    
    // MARK: - Properties
    
    let post: Post
    
    // MARK: - Body
    
    var body: some View {
        Text(.init(post.markdown ?? post.content))
            .redacted(reason: post.markdown == nil ? .placeholder : [])
            .task {
                guard post.markdown == nil else { return }
                
                let demark = Demark()
                let options = DemarkOptions(engine: .htmlToMd)
                
                post.markdown = try? await demark.convertToMarkdown(post.content, options: options)
            }
    }
}

// MARK: - Preview

#Preview {
    
}
