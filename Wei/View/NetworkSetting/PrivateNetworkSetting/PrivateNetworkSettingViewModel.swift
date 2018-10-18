//
//  PrivateNetworkSettingViewModel.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/10/18.
//  Copyright © 2018 yz. All rights reserved.
//

import Foundation

final class PrivateNetworkSettingViewModel: Injectable {
    
    typealias Dependency = (
        ApplicationStoreProtocol
    )
    
    private var applicationStore: ApplicationStoreProtocol
    
    init(dependency: Dependency) {
        self.applicationStore = dependency
    }
    
    func isSelected() -> Bool {
        guard case .private = applicationStore.network else {
            return false
        }
        return true
    }
    
    func save(endpoint: String, chainID: Int) {
        applicationStore.network = Network.private(chainID: chainID, testUse: true)
        applicationStore.privateNetworkEndpoint = endpoint
    }
}
