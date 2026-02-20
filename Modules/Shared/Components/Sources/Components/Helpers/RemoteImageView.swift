//
//  RemoteImageView.swift
//  Components
//
//  Created by Ihor Myronishyn on 16.02.2026.
//

import Nuke
import NukeUI
import SwiftUI
import Entities

struct RemoteImageView<Placeholder: View>: View {
    
    // MARK: - Properties
    
    private let path: String?
    private let mode: ContentMode
    private let processors: [any ImageProcessing]?
    private let placeholder: Placeholder
    
    // MARK: - Init
    
    public init(
        path: String?,
        mode: ContentMode = .fill,
        processors: [any ImageProcessing]? = nil,
        @ViewBuilder placeholder: @escaping () -> Placeholder = { Rectangle().foregroundStyle(.primary.tertiary) }
    ) {
        self.path = path
        self.mode = mode
        self.processors = processors
        self.placeholder = placeholder()
    }
    
    // MARK: - Body
    public var body: some View {
        container
    }
    
    // MARK: - Container
    
    private var container: some View {
        ZStack {
            if let path, let url = URL(string: path) {
                image(for: url)
                    .processors(processors)
            } else {
                placeholder
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        } //: ZStack
    }
    
    // MARK: - Image
    
    private func image(for url: URL) -> LazyImage<some View> {
        LazyImage(url: url) { state in
            ZStack {
                if let image = state.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: mode)
                } else {
                    placeholder
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            } //: ZStack
            .animation(.default, value: state.isLoading)
        } //: LazyImage
    }
}

// MARK: - Preview

#Preview {
    RemoteImageView(path: MediaAttachment.preview.url)
}
