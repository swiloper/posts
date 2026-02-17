//
//  Account.swift
//  Persistence
//
//  Created by Ihor Myronishyn on 17.02.2026.
//

import Entities
import SwiftData
import Foundation

@Model
public final class Account {
    
    // MARK: - Properties
    
    @Attribute(.unique)
    public var id: String
    public var acct: String
    public var username: String
    public var displayName: String
    public var avatar: String
    public var url: String?
    
    @Relationship(inverse: \Post.account)
    public var posts: [Post] = []
    
    // MARK: - Init

    public init(account: Entities.Account) {
        self.id = account.id
        self.acct = account.acct
        self.username = account.username
        self.displayName = account.displayName
        self.avatar = account.avatar
        self.url = account.url
    }
}

// MARK: - Domain

public extension Account {
    func domain() -> Entities.Account {
        Entities.Account(
            id: id,
            acct: acct,
            username: username,
            displayName: displayName,
            avatar: avatar,
            url: url
        )
    }
}
