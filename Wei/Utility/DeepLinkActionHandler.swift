//
//  DeepLinkActionHandler.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/07/12.
//  Copyright © 2018 yz. All rights reserved.
//

import UIKit
import EthereumKit

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
        case .signMessage(let message, let callbackScheme):
            let signedMessage = try walletManager.sign(hex: message)
            print("deeplink action: Sign", signedMessage, callbackScheme)
            
        case .signTransaction(let rawTransaction, let callbackScheme):
            presentSignTransactionViewController(rawTransaction: rawTransaction, actionKind: .sign, scheme: callbackScheme)
            
        case .broadcastTransaction(let rawTransaction, let callbackScheme):
            presentSignTransactionViewController(rawTransaction: rawTransaction, actionKind: .broadcast, scheme: callbackScheme)
        }
    }
    
    private func presentSignTransactionViewController(rawTransaction: RawTransaction, actionKind: SignTransactionViewModel.ActionKind, scheme: String) {
        if AppDelegate.rootViewController.presentedViewController != nil {
            AppDelegate.rootViewController.dismiss(animated: true) { [weak self] in
                self?.presentSignTransactionViewController(rawTransaction: rawTransaction, actionKind: actionKind, scheme: scheme)
            }
        }
        
        let viewController = SignTransactionViewController.make(rawTransaction: rawTransaction, actionKind: actionKind) { [weak self] signature in
            guard let url = self?.buildURL(
                scheme: scheme,
                path: actionKind == .sign ? "/sign_transaction" : "/broadcast_transaction",
                queryItems: URLQueryItem(name: "signature", value: signature)) else {
                    fatalError()
            }
            UIApplication.shared.open(url)
        }
        let navigationController = UINavigationController(rootViewController: viewController)
        AppDelegate.rootViewController.present(navigationController, animated: true)
    }
    
    func buildURL(scheme: String, path: String, queryItems: URLQueryItem...) -> URL? {
        var urlComponents: URLComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = "sdk"
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
}

