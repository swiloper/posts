//
//  PersistenceManager.swift
//  Persistence
//
//  Created by Ihor Myronishyn on 17.02.2026.
//

import Factory
import Entities
import SwiftData
import Foundation

public extension Container {
    @MainActor
    var persistenceManager: Factory<PersistenceManager?> {
        self { @MainActor in
            try? PersistenceManager()
        }.singleton
    }
}

@MainActor
public final class PersistenceManager {
    
    // MARK: - Properties

    public let modelContainer: ModelContainer
    public let modelContext: ModelContext
    
    // MARK: - Init

    public init(inMemory: Bool = false) throws {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: inMemory)

        modelContainer = try ModelContainer(
            for: Feed.self, Post.self,
            configurations: configuration
        )

        modelContext = modelContainer.mainContext
        modelContext.autosaveEnabled = true
    }
}
