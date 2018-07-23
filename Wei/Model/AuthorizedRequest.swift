//
//  AuthorizedRequest.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/07/17.
//  Copyright © 2018 yz. All rights reserved.
//

import APIKit

struct AuthorizedRequest<Request: WeiRequest>: APIKit.Request {
    
    typealias Response = Request.Response
    
    private let baseRequest: Request
    private let accessToken: String
    
    init(_ baseRequest: Request, accessToken: String) {
        self.baseRequest = baseRequest
        self.accessToken = accessToken
    }
    
    var baseURL: URL {
        return baseRequest.baseURL
    }
    
    var path: String {
        return baseRequest.path
    }
    
    var method: HTTPMethod {
        return baseRequest.method
    }
    
    var parameters: Any? {
        return baseRequest.parameters
    }
    
    var headerFields: [String : String] {
        var headerFields = baseRequest.headerFields
        headerFields["Authorization"] = "Bearer \(accessToken)"
        return headerFields
    }
    
    func intercept(urlRequest: URLRequest) throws -> URLRequest {
        return try baseRequest.intercept(urlRequest: urlRequest)
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try baseRequest.response(from: object)
    }
}
