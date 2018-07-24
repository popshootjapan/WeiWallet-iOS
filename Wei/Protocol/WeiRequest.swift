//
//  WeiRequest.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/12.
//  Copyright © 2018 popshoot All rights reserved.
//

import APIKit

protocol WeiRequest: Request {
    var cacheKey: String { get }
    func response(from object: Any) throws -> Response
}

extension WeiRequest {
    var baseURL: URL {
        return Environment.current.weiBaseURL
            .appendingPathComponent("api")
            .appendingPathComponent("v2")
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    private var userAgent: UserAgent {
        return UserAgent.current
    }
    
    var headerFields: [String : String] {
        return [
            "os": "\(userAgent.device)",
            "version": "\(userAgent.version)"
        ]
    }
    
    func intercept(urlRequest: URLRequest) throws -> URLRequest {
        #if DEBUG || INHOUSE
            if let url = urlRequest.url {
                print("\nSent request to \(url)\n", "HeaderFields: \(urlRequest.allHTTPHeaderFields ?? [:])\n")
            }
        #endif
        
        return urlRequest
    }
}

extension WeiRequest {
    var cacheKey: String {
        return [method.rawValue, String(describing: parameters)].joined(separator: ".")
    }
}

extension WeiRequest where Response: Decodable {
    func response(from object: Any) throws -> Response {
        let data = try JSONSerialization.data(withJSONObject: object, options: [])
        return try JSONDecoder().decode(Response.self, from: data)
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        
        if let object = object as? NSCoding {
            Cache.shared.save(object, for: self)
        }
        
        return try response(from: object)
    }
}
