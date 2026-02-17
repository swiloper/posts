//
//  DataLoadingState.swift
//  Utilities
//
//  Created by Ihor Myronishyn on 14.02.2026.
//

import Foundation

public enum DataLoadingState<Value: Equatable> {
    
    // MARK: - Cases
    
    case initial
    case loading
    case loaded(Value)
    case failed(Error)
    
    // MARK: - Properties
    
    public var value: Value? {
        switch self {
        case let .loaded(value):
            value
        default:
            nil
        }
    }
    
    public var isReloadable: Bool {
        switch self {
        case .initial, .failed:
            true
        default:
            false
        }
    }
}

// MARK: - Equatable

extension DataLoadingState: Equatable {
    public static func ==(lhs: DataLoadingState, rhs: DataLoadingState) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial), (.loading, .loading):
            true
        case let (.loaded(lhsValue), .loaded(rhsValue)):
            lhsValue == rhsValue
        case let (.failed(lhsError), .failed(rhsError)):
            lhsError.localizedDescription == rhsError.localizedDescription
        default:
            false
        }
    }
}
