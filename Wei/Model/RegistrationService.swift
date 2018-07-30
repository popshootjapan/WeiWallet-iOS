//
//  RegistrationService.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/18.
//  Copyright © 2018 popshoot All rights reserved.
//

import Foundation
import APIKit

final class RegistrationService {
    struct SignUp: WeiRequest {
        struct Response: Decodable {
            let token: String
        }
        
        let address: String
        let sign: String
        let token: String
        
        var path: String {
            return "sign"
        }
        
        var method: HTTPMethod {
            return .put
        }
        
        var parameters: Any? {
            return [
                "address": address,
                "sign": sign,
                "token": token
            ]
        }
    }
    
    struct AgreeServiceTerms: WeiRequest {        
        struct Response: Decodable {}
        
        var path: String {
            return "agreement_version"
        }
        
        var method: HTTPMethod {
            return .put
        }
    }
}
