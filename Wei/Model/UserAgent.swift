//
//  UserAgent.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/12.
//  Copyright © 2018 popshoot All rights reserved.
//

import UIKit

struct UserAgent {
    let device: String
    let systemVersion: String
    let locale: String
    let version: String
    let buildNumber: String
    
    static var current: UserAgent {
        return UserAgent(device: device.systemName, systemVersion: device.systemVersion, locale: locale, version: version, buildNumber: buildNumber)
    }
    
    static var bundleIdentifier: String {
        return Bundle.main.bundleIdentifier!
    }
    
    private static var device: UIDevice {
        return UIDevice.current
    }
    
    private static var locale: String {
        return Foundation.Locale.preferredLanguages[0]
    }
    
    private static var version: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    private static var buildNumber: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
}

extension UserAgent: CustomDebugStringConvertible {
    var debugDescription: String {
        return """
            os: \(UserAgent.device.systemVersion)
            model: \(UserAgent.device.model)
            version: \(UserAgent.version).\(UserAgent.buildNumber)
        """
    }
}
