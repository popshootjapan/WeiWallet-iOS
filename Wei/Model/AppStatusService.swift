//
//  AppStatusService.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/12.
//  Copyright © 2018 popshoot All rights reserved.
//

import Foundation

final class AppStatusService {
    
    struct GetAppStatus: WeiRequest {
        typealias Response = AppStatus
        
        var path: String {
            return "status"
        }
    }
}
