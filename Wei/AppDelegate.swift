//
//  AppDelegate.swift
//  Wei
//
//  Created by yuzushioh on 2018/03/11.
//  Copyright © 2018 popshoot. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private let deepLinkHandler = Container.shared.resolve(DeepLinkActionHandlerProtocol.self)!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = RootViewController.make()
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        handleDeepLinkAction(url: url)
        return true
    }
    
    private func handleDeepLinkAction(url: URL) {
        do {
            guard let action = try DeepLinkAction(url: url) else {
                return
            }
            deepLinkHandler.execute(action: action)
        } catch let error {
            print(error)
        }
    }
    
    static var rootViewController: RootViewController {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let rootViewController = appDelegate.window?.rootViewController as? RootViewController else {
                fatalError("Unexpected appDelegate \(String(describing: UIApplication.shared.delegate))")
        }
        return rootViewController
    }
}
