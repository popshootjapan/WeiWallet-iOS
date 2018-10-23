//
//  NetworkSettingViewController.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/10/16.
//  Copyright © 2018 yz. All rights reserved.
//

import UIKit

final class NetworkSettingViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    enum DataSource: Int {
        case publicNetwork
        case privateNetwork
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dataSource = DataSource(rawValue: indexPath.row) else {
            return
        }
        
        switch dataSource {
        case .publicNetwork:
            let viewController = PublicNetworkSettingViewController.make()
            navigationController?.pushViewController(viewController, animated: true)
            
        case .privateNetwork:
            let viewController = PrivateNetworkSettingViewController.make()
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
