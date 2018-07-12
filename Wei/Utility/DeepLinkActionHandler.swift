//
//  DeepLinkActionHandler.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/07/12.
//  Copyright © 2018 yz. All rights reserved.
//

import Foundation

protocol DeepLinkActionHandlerProtocol {
    func execute(action: DeepLinkAction) throws
}

final class DeepLinkActionHandler: DeepLinkActionHandlerProtocol, Injectable {
    
    typealias Dependency = (
        WalletManagerProtocol
    )
    
    private let walletManager: WalletManagerProtocol
    
    init(dependency: Dependency) {
        walletManager = dependency
    }
    
    func execute(action: DeepLinkAction) throws {
        switch action {
        case .signMessage(let message):
            let signedMessage = try walletManager.sign(hex: message)
            print("deeplink action: Sign", signedMessage)
            
        case .signTransaction(let rawTransaction):
            let signedTransaction = try walletManager.sign(rawTransaction: rawTransaction)
            print("deeplink action: Sign Transaction", signedTransaction)
        }
    }
}

