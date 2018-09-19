//
//  DeviceChecker.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/18.
//  Copyright © 2018 popshoot All rights reserved.
//

import RxSwift
import RxCocoa
import DeviceCheck

protocol DeviceCheckerProtocol {
    var deviceToken: Observable<String> { get }
}

final class DeviceChecker: DeviceCheckerProtocol {
    
    let deviceToken: Observable<String>
    
    init() {
        deviceToken = Observable.create { observer in
            DCDevice.current.generateToken() { data, error in
                #if targetEnvironment(simulator)
                    observer.onNext("")
                    observer.onCompleted()
                #else
                    if let error = error {
                        observer.onError(error)
                        return
                    }
                
                    guard let token = data?.base64EncodedString() else {
                        observer.onCompleted()
                        return
                    }
                
                    observer.onNext(token)
                    observer.onCompleted()
                #endif
            }
            return Disposables.create()
        }
    }
}
