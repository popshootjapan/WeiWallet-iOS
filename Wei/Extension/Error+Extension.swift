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
            return R.string.localizable.error_title_no_connection()
        case .systemError:
            return R.string.localizable.error_title_about_system()
        }
    }
    
    var message: String? {
        switch self {
        case .connectionError:
            return R.string.localizable.error_message_no_connection()
        case .systemError:
            return R.string.localizable.error_message_about_system()
        }
    }
}

extension EthereumKitError: AlertConvertable {
    var title: String? {
        switch self {
        case .cryptoError, .requestError:
            return R.string.localizable.error_title_about_fatal()
            
        case .responseError(let error):
            switch error {
            case .connectionError:
                return R.string.localizable.error_title_no_connection()
            
            case .jsonrpcError(let error):
                switch error {
                case .responseError(_, let message, _):
                    return message
                    
                default:
                    return R.string.localizable.error_title_about_system()
                }
                
            default:
                return R.string.localizable.error_title_about_system()
            }
        }
    }
    
    var message: String? {
        switch self {
        case .cryptoError, .requestError:
            return R.string.localizable.error_message_about_fatal()
            
        case .responseError(let error):
            switch error {
            case .connectionError:
                return R.string.localizable.error_message_no_connection()
                
            default:
                return R.string.localizable.error_message_about_system()
            }
        }
    }
}
