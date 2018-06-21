//
//  MockAPIClient.swift
//  WeiTests
//
//  Created by Ryo Fukuda on 2018/06/21.
//  Copyright © 2018 yz. All rights reserved.
//

import APIKit
import RxSwift
@testable import Wei

final class MockAPIClient: APIClientProtocol {
    
    enum MockRequest: String, Fixture {
        // RawValueの値は送るリクエストと同一である必要があるので注意
        case GetAppStatus
        
        var resourceName: String {
            return rawValue
        }
    }
    
    func response<Request>(from request: Request) -> Single<Request.Response> where Request: APIKit.Request, Request.Response: Decodable {
        guard let mockRequest = MockRequest(rawValue: String(describing: Request.self)) else {
            fatalError("Request method \(Request.self) is not registered")
        }
        
        do {
            return Single.just(try JSONDecoder().decode(Request.Response.self, from: mockRequest.data))
        } catch let error {
            return Single.error(error)
        }
    }
}

