//
//  Post.swift
//  Persistence
//
//  Created by Ihor Myronishyn on 17.02.2026.
//

import Entities
import SwiftData
import Foundation

@Model
public final class Post {
    
    // MARK: - Properties
    
    @Attribute(.unique)
    public var id: String
    public var createdAt: String
    public var uri: String
    public var url: String?
    public var repliesCount: Int
    public var reblogsCount: Int
    public var favouritesCount: Int
    public var editedAt: String?
    public var content: String

    @Relationship(deleteRule: .cascade)
    public var account: Account

    @Relationship(deleteRule: .cascade)
    public var mediaAttachments: [MediaAttachment]
    
    @Relationship(inverse: \Feed.posts)
    public var feed: Feed?
    
    public var order: Int
    
    // MARK: - Init

    public init(post: Entities.Post, order: Int) {
        self.id = post.id
        self.createdAt = post.createdAt
        self.uri = post.uri
        self.url = post.url
        self.repliesCount = post.repliesCount
        self.reblogsCount = post.reblogsCount
        self.favouritesCount = post.favouritesCount
        self.editedAt = post.editedAt
        self.content = post.content
        self.account = Account(account: post.account)
        self.mediaAttachments = post.mediaAttachments.indices.map({ MediaAttachment(attachment: post.mediaAttachments[$0], order: $0) })
        self.order = order
    }
}

// MARK: - Domain

public extension Post {
    func domain() -> Entities.Post {
        Entities.Post(
            id: id,
            createdAt: createdAt,
            uri: uri,
            url: url,
            repliesCount: repliesCount,
            reblogsCount: reblogsCount,
            favouritesCount: favouritesCount,
            editedAt: editedAt,
            content: content,
            account: account.domain(),
            mediaAttachments: mediaAttachments.sorted(by: { $0.order < $1.order }).map({ $0.domain() })
        )
    }
}
