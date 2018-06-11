//
//  RateService.swift
//  Wei
//
//  Created by Ryosuke Fukuda on 2018/04/05.
//  Copyright © 2018 popshoot All rights reserved.
//

import APIKit

final class RateService {
    
    struct ConvertToFiat: WeiRequest {
        
        typealias Response = Price
        
        let currency: Currency
        let wei: String
        
        var path: String {
            return "eth/convert"
        }
        
        var parameters: Any? {
            return [
                "wei": wei,
                "currency": currency.rawValue
            ]
        }
    }
    
    struct ConvertToEther: WeiRequest {
        
        typealias Response = Price
        
        let currency: Currency
        let fiatAmount: String
        
        var path: String {
            return "fiat/convert"
        }
        
        var parameters: Any? {
            return [
                "amount": fiatAmount,
                "currency": currency.rawValue
            ]
        }
    }
    
    struct GetCurrentRate: WeiRequest {
        
        typealias Response = Price
        
        let currency: Currency
        
        var path: String {
            return "eth/rate"
        }
        
        var parameters: Any? {
            return ["currency": currency.rawValue]
        }
    }
}
