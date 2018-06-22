//
//  Fixture.swift
//  WeiTests
//
//  Created by Ryo Fukuda on 2018/06/21.
//  Copyright © 2018 yz. All rights reserved.
//

import Foundation

protocol Fixture {
    var resourceName: String { get }
}

extension Fixture where Self: RawRepresentable, Self.RawValue == String {
    var data: Data {
        guard let url = Bundle(for: MockAPIClient.self).url(forResource: resourceName, withExtension: "json") else {
            fatalError("Could not file named \(resourceName).json in test bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not read data from file at \(url).")
        }
        
        return data
    }
}

