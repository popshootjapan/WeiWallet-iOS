//
//  URL+WeiExtension.swift
//  Wei
//
//  Created by omatty198 on 2018/04/17.
//  Copyright © 2018年 popshoot All rights reserved.
//

import Foundation

extension URL: WeiExtentionCompatible {}

extension WeiExtention where Base == URL {
    static var terms: URL {
        return URL(string: "https://wei.tokyo/terms")!
    }
    
    static var policy: URL {
        return URL(string: "https://wei.tokyo/policy")!
    }
    
    static var appStoreDetail: URL {
        return URL(string: "itms-apps://itunes.apple.com/app/id1376979142")!
    }
}
