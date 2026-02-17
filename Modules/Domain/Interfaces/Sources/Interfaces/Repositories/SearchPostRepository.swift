//
//  SearchPostRepository.swift
//  Interfaces
//
//  Created by Ihor Myronishyn on 14.02.2026.
//

import Entities
import Foundation

public protocol SearchPostRepository: Sendable {
    func searchPosts(query: String, limit: Int) async throws -> [Post]
}
