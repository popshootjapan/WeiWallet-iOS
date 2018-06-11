//
//  DateFormatter.swift
//  Wei
//
//  Created by Ryosuke Fukuda on 2018/04/14.
//  Copyright © 2018 popshoot All rights reserved.
//

import Foundation

struct DateFormatter {
    private static let fullDateFormatter: Foundation.DateFormatter = {
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/dd HH:mm"
        return dateFormatter
    }()
    
    static func fullDateString(from date: Date) -> String {
        return fullDateFormatter.string(from: date)
    }
}
