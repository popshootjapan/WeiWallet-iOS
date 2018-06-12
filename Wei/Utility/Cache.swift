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

enum CacheKey: String {
    case transactionHistory
}

protocol CacheProtocol {
    func save(_ object: NSCoding, for key: String)
    func load(for key: String) -> Maybe<Any>
    func clear()
}

final class Cache: CacheProtocol {
    
    private let backend = PINCache.shared()
    
    init() {}
    
    func save(_ object: NSCoding, for key: String) {
        DispatchQueue.global().async { [weak backend] in
            backend?.setObject(object, forKey: key)
        }
    }
    
    func load(for key: String) -> Maybe<Any> {
        return Observable<Any>
            .create { [weak backend] observer in
                backend?.object(forKey: key) { caching, key, object in
                    guard let object = object else {
                        observer.onCompleted()
                        return
                    }
                    observer.onNext(object)
                    observer.onCompleted()
                }
                return Disposables.create()
            }
            .observeOn(DriverSharingStrategy.scheduler)
            .asMaybe()
    }
    
    func clear() {
        backend.removeAllObjects()
    }
}

extension CacheProtocol {
    func save<Request: WeiRequest>(_ object: NSCoding, for request: Request) {
        save(object, for: request.cacheKey)
    }
    
    func save<Object: Encodable>(_ object: Object, for cacheKey: CacheKey) {
        guard let data = try? JSONEncoder().encode(object) else {
            return
        }
        save(data as NSCoding, for: cacheKey.rawValue)
    }
    
    func load<Request: WeiRequest>(for request: Request) -> Maybe<Request.Response> where Request.Response: Decodable {
        return load(for: request.cacheKey).flatMap { object -> Maybe<Request.Response> in
            let response = try? request.response(from: object)
            if let response = response {
                return Maybe.just(response)
            }
            return Maybe.empty()
        }
    }
    
    func load<Object: Decodable>(type: Object.Type = Object.self, for cacheKey: CacheKey) -> Maybe<Object> {
        return load(for: cacheKey.rawValue).flatMap { object -> Maybe<Object> in
            let data = object as? Data
            let decoded = data.flatMap { try? JSONDecoder().decode(type, from: $0) }
            if let decoded = decoded {
                return Maybe.just(decoded)
            }
            return Maybe.empty()
        }
    }
}
