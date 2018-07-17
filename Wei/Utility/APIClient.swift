//
//  APIClient.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/23.
//  Copyright © 2018 popshoot All rights reserved.
//

import APIKit
import Result
import RxSwift
import RxCocoa

protocol APIClientProtocol {
    func response<Request>(from request: Request) -> Single<Request.Response>
        where Request: APIKit.Request, Request.Response: Decodable
}

final class APIClient: APIClientProtocol {
    
    private var session: Session = {
        let configuration = URLSessionConfiguration.default
        let adapter = URLSessionAdapter(configuration: configuration)
        return Session(adapter: adapter)
    }()
    
    func response<Request>(from request: Request) -> Single<Request.Response>
        where Request: APIKit.Request, Request.Response: Decodable {
        
            return Single
            .create { [weak session] observer in
                session?.send(request) { result in
                    switch result {
                    case .success(let response):
                        observer(.success(response))
                    case .failure(let error):
                        #if DEBUG
                            print(error)
                        #endif
                        observer(.error(error))
                    }
                }
                return Disposables.create()
            }
            .catchError { throw APIClientError($0) }
    }
}
