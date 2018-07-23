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
    func agreeServiceTerms() -> Single<Void>
}

final class RegistrationRepository: Injectable, RegistrationRepositoryProtocol {
    
    typealias Dependency = (
        APIClientProtocol,
        ApplicationStoreProtocol
    )
    
    private let apiClient: APIClientProtocol
    private let applicationStore: ApplicationStoreProtocol
    
    init(dependency: Dependency) {
        (apiClient, applicationStore) = dependency
    }
    
    func signUp(address: String, sign: String, token: String) -> Single<String> {
        let request = RegistrationService.SignUp(address: address, sign: sign, token: token)
        return apiClient.response(from: request).map { $0.token }
    }
    
    func agreeServiceTerms() -> Single<Void> {
        guard let accessToken = applicationStore.accessToken else {
            fatalError("AccessToken is necessary")
        }
        let request = AuthorizedRequest(RegistrationService.AgreeServiceTerms(), accessToken: accessToken)
        return apiClient.response(from: request).map { _ in }
    }
}
