//
//  TabBarController.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/10/13.
//  Copyright © 2018 yz. All rights reserved.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundImage = UIImage()
        tabBar.backgroundColor = .white
        setTabBar(with: TabBarItem.all)
    }
    
    private func setTabBar(with types: [TabBarItem]) {
        viewControllers = types.map { item -> UIViewController in
            let viewController = item.makeViewController()
            return NavigationController(rootViewController: viewController)
        }
    }
}

enum TabBarItem {
    case wallet
    case browser
    case setting
    
    static var all: [TabBarItem] {
        return [.wallet, .browser, .setting]
    }
}

extension TabBarItem {
    
    private func makeTabBarItem() -> UITabBarItem {
        let items: (String, UIImage, UIImage)
        
        switch self {
        case .wallet:
            items = (
                R.string.localizable.commonWallet(),
                R.image.icon_tabwallet()!,
                R.image.icon_tabwallet()!
            )
            
        case .browser:
            items = (
                R.string.localizable.commonBrowser(),
                R.image.icon_tabbrowser()!,
                R.image.icon_tabbrowser()!
            )
            
        case .setting:
            items = (
                R.string.localizable.commonSetting(),
                R.image.icon_tabsetting()!,
                R.image.icon_tabsetting()!
            )
        }
        
        let tabBarItem = UITabBarItem(
            title: items.0,
            image: items.1,
            selectedImage: items.2
        )
        
        return tabBarItem
    }
    
    fileprivate func makeViewController() -> UIViewController {
        let viewController: UIViewController
        
        switch self {
        case .wallet:
            viewController = HomeViewController.make()
            
        case .browser:
            viewController = BrowserViewController.make()
            
        case .setting:
            viewController = SettingViewController.make()
        }
        
        viewController.tabBarItem = makeTabBarItem()
        return viewController
    }
}
