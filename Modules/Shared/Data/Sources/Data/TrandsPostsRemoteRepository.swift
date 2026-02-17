//
//  TrendsPostsRemoteRepository.swift
//  Data
//
//  Created by Ihor Myronishyn on 13.02.2026.
//

import Config
import Factory
import Entities
import SwiftData
import Interfaces
import Networking
import Foundation
import Persistence

@MainActor
public final class TrendsPostsRepository: FetchPostRepository {
    
    // MARK: - Properties
    
    private let networkService: Networking
    private let persistenceManager: PersistenceManager?
    
    private let cacheKey = "trends"
    private var cacheFetchDescriptor: FetchDescriptor<Persistence.Feed> {
       FetchDescriptor<Persistence.Feed>(predicate: #Predicate { $0.cacheKey == cacheKey })
    }
    
    // MARK: - Init
    
    public init(
        networkService: Networking = Container.shared.networkService(),
        persistenceManager: PersistenceManager? = Container.shared.persistenceManager()
    ) {
        self.networkService = networkService
        self.persistenceManager = persistenceManager
    }
    
    // MARK: - Cached
    
    public func fetchCachedPosts() -> PaginatedResponse<Entities.Post> {
        let emptyResponse = PaginatedResponse(items: [Entities.Post](), offset: .zero)
        
        guard let persistenceManager, let entity = try? persistenceManager.modelContext.fetch(cacheFetchDescriptor).first else {
            return emptyResponse
        }

        let timeToLive: TimeInterval = 5 * 60 // 5 minutes.
        
        if Date().timeIntervalSince(entity.fetchedAt) > timeToLive {
            persistenceManager.modelContext.delete(entity)
            return emptyResponse
        }

        let posts = entity.posts.sorted(by: { $0.order < $1.order }).map({ $0.domain() })
        return PaginatedResponse(items: posts, offset: entity.offset)
    }
    
    // MARK: - Remote
    
    public func fetchRemotePosts(limit: Int, offset: Int) async throws -> PaginatedResponse<Entities.Post> {
        guard let base = Config.base, let token = Config.token else { throw URLError(.badURL) }
        
        let endpoint = Endpoint(
            base: base,
            method: .get,
            headers: .default(with: token),
            path: EndpointPath.trends,
            query: ["limit": limit, "offset": offset]
        )
        
        let posts = try await networkService.request(endpoint: endpoint, decode: [Entities.Post].self)
        let nextOffset = posts.isEmpty ? nil : offset + limit
        
        save(posts: posts, offset: nextOffset)
        
        return PaginatedResponse(items: posts, offset: nextOffset)
    }
    
    // MARK: - Save
    
    private func save(posts: [Entities.Post], offset: Int?) {
        guard let persistenceManager, offset != .zero else { return }
        let context = persistenceManager.modelContext

        let trendsFeedEntity = try? context.fetch(cacheFetchDescriptor).first
        let startIndex = trendsFeedEntity?.posts.count ?? .zero
        let newPostEntities = posts.indices.map({ Persistence.Post(post: posts[$0], order: startIndex + $0) })

        if let trendsFeedEntity {
            trendsFeedEntity.posts.append(contentsOf: newPostEntities)
            trendsFeedEntity.offset = offset
        } else {
            let newEntity = Persistence.Feed(
                cacheKey: cacheKey,
                fetchedAt: Date(),
                posts: newPostEntities,
                offset: offset
            )
            
            context.insert(newEntity)
        }
        
        try? context.save()
    }
}
