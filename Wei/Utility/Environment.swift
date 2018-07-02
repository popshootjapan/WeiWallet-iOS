//
//  Environment.swift
//  Wei
//
//  Created by yuzushioh on 2018/03/15.
//  Copyright © 2018 popshoot. All rights reserved.
//

import Foundation

enum Environment {
    case production
    case development
    case staging
    
    static var current: Environment {
        #if DEBUG
            return .development
        #elseif INHOUSE
            return .staging
        #else
            return .production
        #endif
    }
    
    var weiBaseURL: URL {
        switch self {
        case .development:
            return URL(string: "https://stg.wei.tokyo")!
        case .staging:
            return URL(string: "https://stg.wei.tokyo")!
        case .production:
            return URL(string: "https://wei.tokyo")!
        }
    }
    
    var appGroupID: String {
        switch self {
        case .development:
            return "group.com.popshoot.wei.debug"
        case .staging:
            return "group.com.popshoot.wei.inhouse"
        case .production:
            return "group.com.popshoot.wei"
        }
    }
    
    var nodeEndpoint: String {
        switch self {
        case .production:
            return "https://mainnet.infura.io/z1sEfnzz0LLMsdYMX4PV"
        case .development, .staging:
            return "https://ropsten.infura.io/z1sEfnzz0LLMsdYMX4PV"
        }
    }
    
    var etherscanAPIKey: String {
        return "XE7QVJNVMKJT75ATEPY1HPWTPYCVCKMMJ7"
    }
    
    var debugPrints: Bool {
        switch self {
        case .production, .staging:
            return false
        case .development:
            return true
        }
    }
}
