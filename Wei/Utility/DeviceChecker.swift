//
//  DeviceChecker.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/18.
//  Copyright © 2018 yz. All rights reserved.
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
            if #available(iOS 11.0, *) {
                DCDevice.current.generateToken() { data, error in
                    #if targetEnvironment(simulator)
                        observer.onNext("")
                        observer.onCompleted()
                        return
                    #endif
                    
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
                }
            } else {
                observer.onNext("")
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
