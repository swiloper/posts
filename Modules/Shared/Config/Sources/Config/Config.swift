//
//  Config.swift
//  Config
//
//  Created by Ihor Myronishyn on 13.02.2026.
//

import Foundation

public enum Config {

    // MARK: - Token

    public static var token: String? {
        Bundle.main.token
    }

    // MARK: - Base

    public static var base: String? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Bundle.main.base
        return components.string
    }
}

// MARK: - Bundle

fileprivate extension Bundle {
    var base: String? {
        object(forInfoDictionaryKey: "BASE_URL") as? String
    }
    
    var token: String? {
        object(forInfoDictionaryKey: "TOKEN") as? String
    }
}
