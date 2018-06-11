//
//  UIColor+WeiExtension.swift
//  Wei
//
//  Created by omatty198 on 2018/03/26.
//  Copyright © 2018年 popshoot All rights reserved.
//

import UIKit

extension UIColor: WeiExtentionCompatible {}

extension WeiExtention where Base == UIColor {
    public static var black: UIColor {
        return UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1.0)
    }

    public static var white: UIColor {
        return UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1.0)
    }
    
    public static var placeholder: UIColor {
        return UIColor(red: 182 / 255, green: 192 / 255, blue: 204 / 255, alpha: 1.0)
    }
    
    public static var success: UIColor {
        return UIColor(red: 61 / 255, green: 116 / 255, blue: 242 / 255, alpha: 1.0)
    }
    
    public static var failed: UIColor {
        return UIColor(red: 229 / 255, green: 76 / 255, blue: 94 / 255, alpha: 1.0)
    }
}
