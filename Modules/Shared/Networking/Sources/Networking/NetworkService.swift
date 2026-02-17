//
//  NetworkService.swift
//  Networking
//
//  Created by Ihor Myronishyn on 13.02.2026.
//

import Factory
import Alamofire
import Foundation

public extension Container {
    var networkService: Factory<Networking> {
        self { NetworkService() }.singleton
    }
}

public protocol Networking: Sendable {
    func request<Response: Decodable>(endpoint: Endpoint, decode decodable: Response.Type) async throws -> Response
}

public final class NetworkService: Networking {
    
    // MARK: - Init
    
    public init() {
        // Nothing.
    }
    
    // MARK: - Request
    
    public func request<Response: Decodable & Sendable>(endpoint: Endpoint, decode decodable: Response.Type) async throws -> Response {
        let response = await AF.request(endpoint, interceptor: .retryPolicy)
            .validate()
            .serializingDecodable(Response.self)
            .response
        
        switch response.result {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}
