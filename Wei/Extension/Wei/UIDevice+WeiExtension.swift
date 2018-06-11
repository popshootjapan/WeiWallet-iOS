//
//  UIDevice+WeiExtension.swift
//  Wei
//
//  Created by omatty198 on 2018/05/07.
//  Copyright © 2018年 popshoot All rights reserved.
//

import UIKit

extension UIDevice: WeiExtentionCompatible {}

extension WeiExtention where Base == UIDevice {
    
    static func is3_5Inch() -> Bool {
        return UIScreen.main.bounds.height == 480
    }
    
    static func is4Inch() -> Bool {
        return UIScreen.main.bounds.height == 568
    }
    
    static func isPad() -> Bool {
        return UIScreen.main.bounds.height >= 1024
    }
}
