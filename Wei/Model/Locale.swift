//
//  Locale.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/06/13.
//  Copyright © 2018 yz. All rights reserved.
//

import Foundation

enum Locale {
    case ja
    case en
    
    static func preferred() -> Locale {
        // NOTE: Locale.preferredLanguages() returns ja, ja-JP, or ja-US.
        guard let preferred = Foundation.Locale.preferredLanguages[0].split(separator: "-").first else {
            return .en
        }
        switch preferred {
        case "ja":
            return .ja
        default:
            return .en
        }
    }
    
    func currency() -> Currency {
        switch self {
        case .ja:
            return Currency.jpy
        case .en:
            return Currency.usd
        }
    }
}
