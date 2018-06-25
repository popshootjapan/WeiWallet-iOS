//
//  MockUpdater.swift
//  WeiTests
//
//  Created by Ryo Fukuda on 2018/06/25.
//  Copyright © 2018 yz. All rights reserved.
//

import RxSwift
@testable import Wei

final class MockUpdater: UpdaterProtocol {
    let refreshBalance = PublishSubject<Void>()
    let refreshTransactions = PublishSubject<Void>()
    let refreshRate = PublishSubject<Void>()
}
