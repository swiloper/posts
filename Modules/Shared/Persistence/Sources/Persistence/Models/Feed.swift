//
//  Feed.swift
//  Persistence
//
//  Created by Ihor Myronishyn on 17.02.2026.
//

import SwiftData
import Foundation

@Model
public final class Feed {
    
    // MARK: - Properties
    
    @Attribute(.unique)
    public var cacheKey: String
    public var fetchedAt: Date

    @Relationship(deleteRule: .cascade)
    public var posts: [Post]
    public var offset: Int?
    
    // MARK: - Init

    public init(cacheKey: String, fetchedAt: Date, posts: [Post], offset: Int?) {
        self.cacheKey = cacheKey
        self.fetchedAt = fetchedAt
        self.posts = posts
        self.offset = offset
    }
}
