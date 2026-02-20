//
//  Post.swift
//  Entities
//
//  Created by Ihor Myronishyn on 13.02.2026.
//

import Utilities
import Foundation

import SwiftData

@Observable
public final class Post: Codable, Identifiable, @unchecked Sendable {
    
    // MARK: - Properties
    
    @ObservationIgnored
    public let id: String
    @ObservationIgnored
    public let createdAt: String
    @ObservationIgnored
    public let uri: String
    @ObservationIgnored
    public let url: String?
    @ObservationIgnored
    public let repliesCount: Int
    @ObservationIgnored
    public let reblogsCount: Int
    @ObservationIgnored
    public let favouritesCount: Int
    @ObservationIgnored
    public let editedAt: String?
    @ObservationIgnored
    public let content: String
    @ObservationIgnored
    public let account: Account
    @ObservationIgnored
    public let mediaAttachments: [MediaAttachment]
    
    public var markdown: String? = nil
    
    public var relativeCreatedAt: String {
        guard let date = createdAt.iso8601Date() else { return "" }
        return date.relativeString
    }
    
    // MARK: - Init
    
    public init(id: String, createdAt: String, uri: String, url: String?, repliesCount: Int, reblogsCount: Int, favouritesCount: Int, editedAt: String? = nil, content: String, account: Account, mediaAttachments: [MediaAttachment]) {
        self.id = id
        self.createdAt = createdAt
        self.uri = uri
        self.url = url
        self.repliesCount = repliesCount
        self.reblogsCount = reblogsCount
        self.favouritesCount = favouritesCount
        self.editedAt = editedAt
        self.content = content
        self.account = account
        self.mediaAttachments = mediaAttachments
    }
    
    // MARK: - Keys
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case uri, url
        case repliesCount = "replies_count"
        case reblogsCount = "reblogs_count"
        case favouritesCount = "favourites_count"
        case editedAt = "edited_at"
        case content, account
        case mediaAttachments = "media_attachments"
    }
}

// MARK: - Equatable

extension Post: Equatable {
    public static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id &&
        lhs.createdAt == rhs.createdAt &&
        lhs.uri == rhs.uri &&
        lhs.url == rhs.url &&
        lhs.repliesCount == rhs.repliesCount &&
        lhs.reblogsCount == rhs.reblogsCount &&
        lhs.favouritesCount == rhs.favouritesCount &&
        lhs.editedAt == rhs.editedAt &&
        lhs.content == rhs.content &&
        lhs.account == rhs.account &&
        lhs.mediaAttachments == rhs.mediaAttachments
    }
}

// MARK: - Hashable

extension Post: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(createdAt)
        hasher.combine(uri)
        hasher.combine(url)
        hasher.combine(repliesCount)
        hasher.combine(reblogsCount)
        hasher.combine(favouritesCount)
        hasher.combine(editedAt)
        hasher.combine(content)
        hasher.combine(account)
        hasher.combine(mediaAttachments)
    }
}

// MARK: - Preview

public extension Post {
    static let preview = Post(
        id: "116100948206882049",
        createdAt: "2026-02-20T03:57:56.000Z",
        uri: "https://mastodonapp.uk/users/GetCarter/statuses/116100948079210585",
        url: "https://mastodonapp.uk/@GetCarter/116100948079210585",
        repliesCount: .zero,
        reblogsCount: 56,
        favouritesCount: 95,
        content: "<p>The first proper view of Liathach as one travels down Glen Torridon never fails to impress. Photo: Yesterday morning.</p>",
        account: .preview,
        mediaAttachments: [.preview]
    )
}
