//
//  UITableView+Extension.swift
//  Wei
//
//  Created by Ryosuke Fukuda on 2018/04/14.
//  Copyright © 2018 popshoot All rights reserved.
//


import UIKit

extension UITableView {
    func deselectSelectedRows(animated: Bool) {
        indexPathsForSelectedRows?.forEach { indexPath in
            deselectRow(at: indexPath, animated: animated)
        }
    }
    
    func dequeueReusableCell<T: UITableViewCell>(withType type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: type), for: indexPath) as? T else {
            fatalError("You must register \(type) first.")
        }
        return cell
    }
}
