//
//  MediaAttachmentsView.swift
//  Trends
//
//  Created by Ihor Myronishyn on 14.02.2026.
//

import Files
import SwiftUI
import Factory
import Entities

struct MediaAttachmentsView: View {
    
    // MARK: - Properties
    
    @InjectedObservable(\.quickLookManager) var quickLookManager
    
    @State private var selected: MediaAttachment? = nil
    
    let attachments: [MediaAttachment]
    
    // MARK: - Methods
    
    private func openQuickLook(for attachment: MediaAttachment) {
        guard let selectedRemoteFileLink = attachment.url, let selectedRemoteFileURL = URL(string: selectedRemoteFileLink) else { return }

        selected = attachment

        let remoteFilesURLs: [URL] = attachments.compactMap {
            guard let link = $0.url else { return nil }
            return URL(string: link)
        }

        quickLookManager.present(selectedRemoteFileURL: selectedRemoteFileURL, in: remoteFilesURLs)
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            if attachments.count == 1, let item = attachments.first {
                cell(for: item)
                    .aspectRatio(item.meta?.small?.ratio ?? 1, contentMode: .fit)
            } else {
                if attachments.count > 2 {
                    grid
                        .aspectRatio(1, contentMode: .fit)
                } else {
                    grid
                }
            }
        } //: ZStack
        .frame(maxWidth: .infinity)
        .clipShape(.rect(cornerRadius: 12))
    }
    
    // MARK: - Grid
    
    private var grid: some View {
        Grid(horizontalSpacing: 4, verticalSpacing: 4) {
            ForEach(Array(stride(from: .zero, to: attachments.count, by: 2)), id: \.self) { index in
                if index == attachments.indices.last {
                    cell(for: attachments[index])
                        .gridCellColumns(attachments.count % 2 != .zero ? 2 : 1)
                } else {
                    GridRow {
                        Group {
                            cell(for: attachments[index])
                            cell(for: attachments[index + 1])
                        } //: Group
                        .aspectRatio(1, contentMode: .fit)
                    } //: GridRow
                }
            } //: ForEach
        } //: Grid
    }
    
    // MARK: - Cell
    
    private func cell(for attachment: MediaAttachment) -> some View {
        Button {
            openQuickLook(for: attachment)
        } label: {
            GeometryReader { proxy in
                preview(for: attachment)
                    .frame(width: proxy.size.width, height: proxy.size.height)
            } //: GeometryReader
            .clipped()
            .allowsHitTesting(false)
            .contentShape(.rect)
        } //: Button
        .buttonStyle(.plain)
    }
    
    // MARK: - Preview
    
    private func preview(for attachment: MediaAttachment) -> some View {
        ZStack {
            RemoteImageView(path: attachment.preview)
            
            if let selected, selected.id == attachment.id, quickLookManager.state == .loading {
                Color.black.opacity(0.25)
                ProgressView()
            } else {
                if attachment.type == .video {
                    Image(systemName: "play.fill")
                        .foregroundStyle(.white)
                        .frame(width: 38, height: 38)
                        .background(Material.ultraThinMaterial)
                        .environment(\.colorScheme, .dark)
                        .clipShape(.circle)
                } else if attachment.type == .audio {
                    GeometryReader { proxy in
                        Image(systemName: "music.note")
                            .font(.system(size: proxy.size.height / 3))
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                            .frame(width: proxy.size.width, height: proxy.size.height)
                    } //: GeometryReader
                }
            }
        } //: ZStack
    }
}

// MARK: - Preview

#Preview {
    
}
