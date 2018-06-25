//
//  MockRateRepository.swift
//  WeiTests
//
//  Created by Ryo Fukuda on 2018/06/22.
//  Copyright © 2018 yz. All rights reserved.
//

import RxSwift
import RxCocoa
@testable import Wei

final class MockRateRepository: RateRepositoryProtocol {
    func convertToFiat(from wei: String, to currency: Currency) -> Single<Price> {
        return Single.just(Price(price: "1000.55", currency: currency.rawValue))
    }
    
    func convertToEther(from fiatAmount: String, to currency: Currency) -> Single<Price> {
        return Single.just(Price(price: "1.5", currency: currency.rawValue))
    }
    
    func getCurrentRate(currency: Currency) -> Single<Price> {
        return Single.just(Price(price: "5000", currency: currency.rawValue))
    }
}
