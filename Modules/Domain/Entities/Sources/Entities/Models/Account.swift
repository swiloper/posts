//
//  Account.swift
//  Entities
//
//  Created by Ihor Myronishyn on 13.02.2026.
//

import Foundation

public struct Account: Codable, Identifiable, Hashable, Sendable {
    
    // MARK: - Properties
    
    public let id: String
    public let acct: String
    public let username: String
    public let displayName: String
    public let avatar: String
    public let url: String?
    
    // MARK: - Init
    
    public init(id: String, acct: String, username: String, displayName: String, avatar: String, url: String?) {
        self.id = id
        self.acct = acct
        self.username = username
        self.displayName = displayName
        self.avatar = avatar
        self.url = url
    }
    
    // MARK: - Keys
    
    enum CodingKeys: String, CodingKey {
        case id, acct, username
        case displayName = "display_name"
        case avatar = "avatar"
        case url
    }
}
