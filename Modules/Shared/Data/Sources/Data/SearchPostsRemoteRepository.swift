//
//  SearchPostsRemoteRepository.swift
//  Data
//
//  Created by Ihor Myronishyn on 14.02.2026.
//

import Config
import Factory
import Entities
import Interfaces
import Networking
import Foundation

public final class SearchPostsRemoteRepository: SearchPostRepository {
    
    // MARK: - Properties
    
    private let networkService: Networking
    
    // MARK: - Init
    
    public init(networkService: Networking = Container.shared.networkService()) {
        self.networkService = networkService
    }
    
    // MARK: - Fetch
    
    public func searchPosts(query: String, limit: Int) async throws -> [Post] {
        guard let base = Config.base, let token = Config.token else { throw URLError(.badURL) }
        
        let endpoint = Endpoint(
            base: base,
            method: .get,
            headers: .default(with: token),
            path: EndpointPath.search,
            query: ["limit": limit, "q": query, "type": "statuses"]
        )
        
        let response = try await networkService.request(endpoint: endpoint, decode: SearchResponse.self)
        return response.posts
    }
}
