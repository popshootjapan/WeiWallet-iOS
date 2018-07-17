//
//  AppStatusRepository.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/12.
//  Copyright © 2018 popshoot All rights reserved.
//

import RxSwift
import RxCocoa

protocol AppStatusRepositoryProtocol {
    func getAppStatus() -> Single<AppStatus>
}

final class AppStatusRepository: Injectable, AppStatusRepositoryProtocol {
    
    typealias Dependency = (
        APIClientProtocol,
        ApplicationStoreProtocol
    )
    
    private let apiClient: APIClientProtocol
    private let applicationStore: ApplicationStoreProtocol
    
    init(dependency: Dependency) {
        (apiClient, applicationStore) = dependency
    }
    
    func getAppStatus() -> Single<AppStatus> {
        let request = HTTPRequest(AppStatusService.GetAppStatus(), accessToken: applicationStore.accessToken)
        return apiClient.response(from: request)
    }
}
