//
//  DebugListViewController.swift
//  Wei
//
//  Created by yuzushioh on 2018/05/06.
//  Copyright © 2018 popshoot All rights reserved.
//

import UIKit
import Swinject

final class DebugListViewController: UITableViewController {
    
    @IBOutlet private weak var versionLabel: UILabel! {
        didSet {
            versionLabel.text = UserAgent.current.debugDescription
        }
    }
    
    private let appicationStore = Container.shared.resolve(ApplicationStoreProtocol.self)!
    
    @IBAction private func cancelButtonDidTap(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showAlertController(title: "Clear keychain?", withCancel: true) { [weak self] _ in
            self?.appicationStore.clearData()
            Cache.shared.clear()
            self?.dismiss(animated: true)
        }
    }
}
