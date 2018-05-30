//
//  Injectable.swift
//  Wei
//
//  Created by Ryosuke Fukuda on 2018/03/15.
//  Copyright © 2018 yz. All rights reserved.
//

protocol Injectable {
    associatedtype Dependency
    init(dependency: Dependency)
}
