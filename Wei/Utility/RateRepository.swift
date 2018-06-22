//
//  RateRepository.swift
//  Wei
//
//  Created by Ryosuke Fukuda on 2018/04/05.
//  Copyright © 2018 popshoot All rights reserved.
//

import RxSwift
import RxCocoa

protocol RateRepositoryProtocol {
    func convertToFiat(from wei: String, to currency: Currency) -> Single<Price>
    func convertToEther(from fiatAmount: String, to currency: Currency) -> Single<Price>
    func getCurrentRate(currency: Currency) -> Single<Price>
}

final class RateRepository: Injectable, RateRepositoryProtocol {
    
    typealias Dependency = (
        APIClientProtocol
    )
    
    private let apiClient: APIClientProtocol
    
    init(dependency: Dependency) {
        apiClient = dependency
    }
    
    func convertToFiat(from wei: String, to currency: Currency) -> Single<Price> {
        let request = RateService.ConvertToFiat(currency: currency, wei: wei)
        return apiClient.response(from: request)
    }
    
    func convertToEther(from fiatAmount: String, to currency: Currency) -> Single<Price> {
        let request = RateService.ConvertToEther(currency: currency, fiatAmount: fiatAmount)
        return apiClient.response(from: request)
    }
    
    func getCurrentRate(currency: Currency) -> Single<Price> {
        let request = RateService.GetCurrentRate(currency: currency)
        return apiClient.response(from: request)
    }
}
