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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = RootViewController.make()
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        
        return true
    }
    
    static var rootViewController: RootViewController {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let rootViewController = appDelegate.window?.rootViewController as? RootViewController else {
                fatalError("Unexpected appDelegate \(String(describing: UIApplication.shared.delegate))")
        }
        return rootViewController
    }
}
