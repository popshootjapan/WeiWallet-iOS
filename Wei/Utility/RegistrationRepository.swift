//
//  RegistrationRepository.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/18.
//  Copyright © 2018 popshoot All rights reserved.
//

import RxSwift
import RxCocoa

protocol RegistrationRepositoryProtocol {
    func signUp(address: String, sign: String, token: String) -> Single<String>
}

final class RegistrationRepository: Injectable, RegistrationRepositoryProtocol {
    
    typealias Dependency = (
        APIClientProtocol
    )
    
    private let apiClient: APIClientProtocol
    
    init(dependency: Dependency) {
        apiClient = dependency
    }
    
    func signUp(address: String, sign: String, token: String) -> Single<String> {
        let request = RegistrationService.SignUp(address: address, sign: sign, token: token)
        return apiClient.response(from: request).map { $0.token }
    }
}
