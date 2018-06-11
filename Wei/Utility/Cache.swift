//
//  Cache.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/12.
//  Copyright © 2018 popshoot All rights reserved.
//

import PINCache
import RxSwift
import RxCocoa

protocol CacheProtocol {
    func save<Request: WeiRequest>(_ object: NSCoding, for request: Request)
    func load<Request: WeiRequest>(for request: Request) -> Maybe<Request.Response> where Request.Response: Decodable
    func clear()
}

final class Cache: CacheProtocol {
    
    private let backend = PINCache.shared()
    
    init() {}
    
    func save<Request>(_ object: NSCoding, for request: Request) where Request: WeiRequest {
        DispatchQueue.global().async { [weak backend] in
            backend?.setObject(object, forKey: request.cacheKey)
        }
    }
    
    func load<Request>(for request: Request) -> Maybe<Request.Response> where Request: WeiRequest, Request.Response: Decodable {
        return Observable<Request.Response>
            .create { [weak backend] observer in
                backend?.object(forKey: request.cacheKey) { caching, key, object in
                    guard let object = object else {
                        observer.onCompleted()
                        return
                    }
                    
                    let response: Request.Response
                    do {
                        response = try request.response(from: object)
                    } catch let error {
                        observer.onError(error)
                        observer.onCompleted()
                        return
                    }
                    
                    observer.onNext(response)
                    observer.onCompleted()
                }
                
                return Disposables.create()
            }
            .asMaybe()
    }
    
    func clear() {
        backend.removeAllObjects()
    }
}
