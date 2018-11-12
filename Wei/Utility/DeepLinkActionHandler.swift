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
    func execute(action: DeepLinkAction)
}

final class DeepLinkActionHandler: DeepLinkActionHandlerProtocol, Injectable {
    
    typealias Dependency = (
        WalletManagerProtocol
    )
    
    private let walletManager: WalletManagerProtocol
    
    init(dependency: Dependency) {
        walletManager = dependency
    }
    
    func execute(action: DeepLinkAction) {
        switch action {
        case .signMessage(let message, let callbackScheme):
            presentSignMessageAlertController(message: message, scheme: callbackScheme)
            
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
        
        let viewController = SignTransactionViewController.make(rawTransaction: rawTransaction, actionKind: actionKind) { [weak self] string in
            let url: URL
            switch actionKind {
            case .sign:
                guard let builtURL = self?.buildURL(scheme: scheme, path: "/sign_transaction", queryItems: URLQueryItem(name: "signature", value: string)) else {
                    fatalError("Failed to build url for SDK")
                }
                url = builtURL
                
            case .broadcast:
                guard let builtURL = self?.buildURL(scheme: scheme, path: "/broadcast_transaction", queryItems: URLQueryItem(name: "txid", value: string)) else {
                    fatalError("Failed to build url for SDK")
                }
                url = builtURL
            }
            UIApplication.shared.open(url)
        }
        let navigationController = UINavigationController(rootViewController: viewController)
        AppDelegate.rootViewController.present(navigationController, animated: true)
    }
    
    private func presentSignMessageAlertController(message: String, scheme: String) {
        if AppDelegate.rootViewController.presentedViewController != nil {
            AppDelegate.rootViewController.dismiss(animated: true) { [weak self] in
                self?.presentSignMessageAlertController(message: message, scheme: scheme)
            }
        }
        
        let signedMessage: String?
        do {
            signedMessage = try walletManager.personalSign(hex: message)
        } catch let error {
            fatalError("Failed to sign a message: \(error.localizedDescription)")
        }
        
        guard let signature = signedMessage else {
            fatalError()
        }
        
        // TODO:
        let alertController = UIAlertController(title: "Signing a message", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let url = self?.buildURL(scheme: scheme, path: "/sign_personal_message", queryItems: URLQueryItem(name: "signature", value: signature)) else {
                fatalError("Failed to build url for SDK")
            }
            print(url)
            UIApplication.shared.open(url)
        })
        
        alertController.addAction(UIAlertAction(title: R.string.localizable.commonCancel(), style: .cancel))
        AppDelegate.rootViewController.present(alertController, animated: true)
    }
    
    private func buildURL(scheme: String, path: String, queryItems: URLQueryItem...) -> URL? {
        var urlComponents: URLComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = "sdk"
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
}

