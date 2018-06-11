//
//  APIClientError.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/25.
//  Copyright © 2018 popshoot All rights reserved.
//

import APIKit

enum APIClientError: Error {
    case systemError(Error)
    case connectionError(Error)
    
    init(_ error: Error) {
        switch error {
        case SessionTaskError.connectionError(let error):
            self = .connectionError(error)
            
        default:
            self = .systemError(error)
        }
    }
}
