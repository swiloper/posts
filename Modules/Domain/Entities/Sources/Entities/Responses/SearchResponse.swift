//
//  SearchResponse.swift
//  Entities
//
//  Created by Ihor Myronishyn on 14.02.2026.
//

import Foundation

public struct SearchResponse: Decodable {
    
    // MARK: - Properties
    
    public let posts: [Post]
    
    // MARK: - Keys
    
    enum CodingKeys: String, CodingKey {
        case posts = "statuses"
    }
}
