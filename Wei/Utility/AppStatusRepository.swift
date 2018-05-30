//
//  AppStatusRepository.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/12.
//  Copyright © 2018 yz. All rights reserved.
//

import RxSwift
import RxCocoa

protocol AppStatusRepositoryProtocol {
    func getAppStatus() -> Single<AppStatus>
}

final class AppStatusRepository: Injectable, AppStatusRepositoryProtocol {
    
    typealias Dependency = (
        APIClientProtocol
    )
    
    private let apiClient: APIClientProtocol
    
    init(dependency: Dependency) {
        apiClient = dependency
    }
    
    func getAppStatus() -> Single<AppStatus> {
        let request = AppStatusService.GetAppStatus()
        return apiClient.response(from: request)
    }
}
