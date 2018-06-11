//
//  UIApplication+WeiExtension.swift
//  Wei
//
//  Created by omatty198 on 2018/04/26.
//  Copyright © 2018年 popshoot All rights reserved.
//

import UIKit

extension UIApplication: WeiExtentionCompatible {}

extension WeiExtention where Base == UIApplication {
    static func openAppStore() {
        if UIApplication.shared.canOpenURL(URL.wei.appStoreDetail) {
            UIApplication.shared.open(URL.wei.appStoreDetail)
        }
    }
}
