//
//  PaginatedResponse.swift
//  Entities
//
//  Created by Ihor Myronishyn on 14.02.2026.
//

import Foundation

public struct PaginatedResponse<Item: Decodable & Sendable>: Decodable, Sendable {
    
    // MARK: - Properties
    
    public let items: [Item]
    public let offset: Int?
    
    // MARK: - Init
    
    public init(items: [Item], offset: Int?) {
        self.items = items
        self.offset = offset
    }
    
    // MARK: - Keys
    
    enum CodingKeys: String, CodingKey {
        case items, offset
    }
}
