//
//  Wei+Extension.swift
//  Wei
//
//  Created by omatty198 on 2018/03/26.
//  Copyright © 2018年 popshoot All rights reserved.
//

import Foundation

public struct WeiExtention<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol WeiExtentionCompatible {
    associatedtype Compatible
    static var wei: WeiExtention<Compatible>.Type { get }
    var wei: WeiExtention<Compatible> { get }
}

extension WeiExtentionCompatible {
    public static var wei: WeiExtention<Self>.Type {
        return WeiExtention<Self>.self
    }

    public var wei: WeiExtention<Self> {
        return WeiExtention(self)
    }
}
