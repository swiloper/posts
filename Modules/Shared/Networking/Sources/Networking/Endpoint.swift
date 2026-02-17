//
//  Endpoint.swift
//  Networking
//
//  Created by Ihor Myronishyn on 13.02.2026.
//

import Alamofire
import Foundation

public struct Endpoint: URLRequestConvertible, Sendable {
    
    // MARK: - Properties
    
    public var base: String
    public var method: HTTPMethod
    public var headers: HTTPHeaders?
    public var path: String
    public var query: Parameters?
    public var body: Body?
    
    public typealias Body = Encodable & Sendable
    
    // MARK: - Init
    
    public init(base: String, method: HTTPMethod, headers: HTTPHeaders? = nil, path: String, query: Parameters? = nil, body: Body? = nil) {
        self.base = base
        self.method = method
        self.headers = headers
        self.path = path
        self.query = query
        self.body = body
    }
    
    // MARK: - Methods
    
    public func asURLRequest() throws -> URLRequest {
        let url = try base.asURL().appendingPathComponent(path)
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let headers {
            request.headers = headers
        }
        
        if let query {
            let encoder = URLEncoding(destination: .queryString, boolEncoding: .literal)
            request = try encoder.encode(request, with: query)
        }
        
        if let body {
            let encoder = JSONParameterEncoder()
            encoder.encoder.outputFormatting = .sortedKeys
            request = try encoder.encode(body, into: request)
        }
        
        return request
    }
}

// MARK: - Headers

extension HTTPHeaders {
    public static func `default`(with token: String) -> HTTPHeaders {
        [.accept("application/json"), .authorization(bearerToken: token)]
    }
}
