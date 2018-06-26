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
            return R.string.localizable.errorTitleNoConnection()
        case .systemError:
            return R.string.localizable.errorTitleSystemError()
        }
    }
    
    var message: String? {
        switch self {
        case .connectionError:
            return R.string.localizable.errorMessageNoConnection()
        case .systemError:
            return R.string.localizable.errorMessageSystemError()
        }
    }
}

extension EthereumKitError: AlertConvertable {
    var title: String? {
        switch self {
        case .cryptoError, .requestError:
            return R.string.localizable.errorTitleUnexpected()
            
        case .responseError(let error):
            switch error {
            case .connectionError:
                return R.string.localizable.errorTitleNoConnection()
            
            case .jsonrpcError(let error):
                switch error {
                case .responseError(_, let message, _):
                    return message
                    
                default:
                    return R.string.localizable.errorTitleSystemError()
                }
                
            default:
                return R.string.localizable.errorTitleSystemError()
            }
            
        case .contractError, .convertError:
            fatalError("EthereumKit.ContractError should not be thrown in Wei wallet")
        }
    }
    
    var message: String? {
        switch self {
        case .cryptoError, .requestError:
            return R.string.localizable.errorMessageUnexpected()
            
        case .responseError(let error):
            switch error {
            case .connectionError:
                return R.string.localizable.errorMessageNoConnection()
                
            default:
                return R.string.localizable.errorMessageSystemError()
            }
            
        case .contractError, .convertError:
            fatalError("EthereumKit.ContractError should not be thrown in Wei wallet")
        }
    }
}
