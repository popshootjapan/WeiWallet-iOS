//
//  Formatter.swift
//  Wei
//
//  Created by omatty198 on 2018/04/26.
//  Copyright © 2018年 popshoot All rights reserved.
//

import Foundation

struct Formatter {
    private static var decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    static func decimalString(from number: NSNumber) -> String? {
        return decimalFormatter.string(from: number)
    }
}
