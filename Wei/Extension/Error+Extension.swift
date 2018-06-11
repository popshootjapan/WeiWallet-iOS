//
//  Error+Extension.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/25.
//  Copyright © 2018 popshoot All rights reserved.
//

import Foundation
import EthereumKit

extension APIClientError: AlertConvertable {
    var title: String? {
        switch self {
        case .connectionError:
            return "通信ができません"
        case .systemError:
            return "システムエラーです"
        }
    }
    
    var message: String? {
        switch self {
        case .connectionError:
            return "電波の良い場所で再度お試しください"
        case .systemError:
            return "時間を空けて再度お試しください"
        }
    }
}

extension EthereumKitError: AlertConvertable {
    var title: String? {
        switch self {
        case .cryptoError, .requestError:
            return "予期せぬエラーが発生しました"
            
        case .responseError(let error):
            switch error {
            case .connectionError:
                return "通信ができません"
            
            case .jsonrpcError(let error):
                switch error {
                case .responseError(_, let message, _):
                    return message
                    
                default:
                    return "システムエラーです"
                }
                
            default:
                return "システムエラーです"
            }
        }
    }
    
    var message: String? {
        switch self {
        case .cryptoError, .requestError:
            return "一度アプリを再起動してください"
            
        case .responseError(let error):
            switch error {
            case .connectionError:
                return "電波の良い場所で再度お試しください"
                
            default:
                return "時間を空けて再度お試しください"
            }
        }
    }
}
