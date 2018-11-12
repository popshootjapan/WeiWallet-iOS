//
//  WKWebViewConfiguration+Extension.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/11/12.
//  Copyright © 2018 yz. All rights reserved.
//

import Foundation
import WebKit
import JavaScriptCore
import Swinject

extension WKWebViewConfiguration {
    
    static func make(address: String, in messageHandler: WKScriptMessageHandler) -> WKWebViewConfiguration {
        let config = WKWebViewConfiguration()
        var js = ""
        
        guard
            let bundlePath = Bundle.main.path(forResource: "TrustWeb3Provider", ofType: "bundle"),
            let bundle = Bundle(path: bundlePath) else {
                return config
        }
        
        if let filepath = bundle.path(forResource: "trust-min", ofType: "js") {
            do {
                js += try String(contentsOfFile: filepath)
            } catch {
                fatalError()
            }
        }
        
        let store = Container.shared.resolve(UserDefaultsStoreProtocol.self)!
        
        print(#function, #line, address.lowercased(), Environment.current.nodeEndpoint, store.chainID.description)
        
        js +=
        """
        const addressHex = "\(address.lowercased())"
        const rpcURL = "\(Environment.current.nodeEndpoint)"
        const chainID = "\(3.description)"
        console.log("Hello WeiWallet")
        
        function executeCallback (id, error, value) {
        Trust.executeCallback(id, error, value)
        }
        
        Trust.init(rpcURL, {
        signMessage: function (msgParams, cb) {
        const { data } = msgParams
        const { id = 8888 } = msgParams
        console.log("signing a message", msgParams)
        Trust.addCallback(id, cb)
        webkit.messageHandlers.signMessage.postMessage({"name": "signMessage", "object": { data }, id: id})
        },
        signPersonalMessage: function (msgParams, cb) {
        const { data } = msgParams
        const { id = 8888 } = msgParams
        console.log("signing a personal message", msgParams)
        Trust.addCallback(id, cb)
        webkit.messageHandlers.signPersonalMessage.postMessage({"name": "signPersonalMessage", "object": { data }, id: id})
        },
        }, {
        address: addressHex,
        networkVersion: chainID
        })
        
        web3.setProvider = function () {
        console.debug('Trust Wallet - overrode web3.setProvider')
        }
        
        web3.eth.defaultAccount = addressHex
        
        web3.version.getNetwork = function(cb) {
        cb(null, chainID)
        }
        
        web3.eth.getCoinbase = function(cb) {
        return cb(null, addressHex)
        }
        
        """
        let userScript = WKUserScript(source: js, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        config.userContentController.add(messageHandler, name: Method.signTransaction.rawValue)
        config.userContentController.add(messageHandler, name: Method.signPersonalMessage.rawValue)
        config.userContentController.add(messageHandler, name: Method.signMessage.rawValue)
        config.userContentController.addUserScript(userScript)
        return config
    }
}

enum Method: String, Decodable {
    case signTransaction
    case signPersonalMessage
    case signMessage
    case unknown
    
    init(string: String) {
        self = Method(rawValue: string) ?? .unknown
    }
}

final class ScriptMessageProxy: NSObject, WKScriptMessageHandler {
    
    weak var delegate: WKScriptMessageHandler?
    
    init(delegate: WKScriptMessageHandler) {
        self.delegate = delegate
        super.init()
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        self.delegate?.userContentController(userContentController, didReceive: message)
    }
}
