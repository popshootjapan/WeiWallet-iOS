//
//  Logger.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/11/12.
//  Copyright © 2018 yz. All rights reserved.
//

import Foundation
import os.log

struct LogCategory {
    static var general = OSLog(subsystem: UserAgent.bundleIdentifier, category: "general")
    static var personalSign = OSLog(subsystem: UserAgent.bundleIdentifier, category: "personalSign")
}

struct Logger {
    
    static var osLog: OSLog = LogCategory.general
    
    static func info(file: String = #file, function: String = #function, line: Int = #line, osLog: OSLog = osLog, message: String) {
        doLog(file: file, function: function, line: line, message: message, osLog: osLog, logType: .info)
    }
    
    static func debug(file: String = #file, function: String = #function, line: Int = #line, osLog: OSLog = osLog, message: String) {
        doLog(file: file, function: function, line: line, message: message, osLog: osLog, logType: .debug)
    }
    
    static func error(file: String = #file, function: String = #function, line: Int = #line, osLog: OSLog = osLog, message: String) {
        doLog(file: file, function: function, line: line, message: message, osLog: osLog, logType: .error)
    }
    
    static func fault(file: String = #file, function: String = #function, line: Int = #line, osLog: OSLog = osLog, message: String) {
        doLog(file: file, function: function, line: line, message: message, osLog: osLog, logType: .fault)
    }
    
    static func `default`(file: String = #file, function: String = #function, line: Int = #line, osLog: OSLog = osLog, message: String) {
        doLog(file: file, function: function, line: line, message: message, osLog: osLog)
    }
    
    private static func className(from filePath: String) -> String {
        let fileName = filePath.components(separatedBy: "/").last
        return fileName?.components(separatedBy: ".").first ?? ""
    }
    
    private static func doLog(file: String, function: String, line: Int, message: String, osLog: OSLog, logType: OSLogType = .default) {
        #if !PRODUCTION
        os_log("everip [%@]: %@", log: osLog, type: logType, logType.string(), "\(className(from: file)).\(function) #\(line): \(message)")
        #endif
    }
}

extension OSLogType {
    func string() -> String {
        switch self.rawValue {
        case 0:
            return "DEFAULT"
        case 1:
            return "INFO"
        case 2:
            return "DEBUG"
        case 3:
            return "ERROR"
        case 4:
            return "FAULT"
        default:
            return "DEFAULT"
        }
    }
}
