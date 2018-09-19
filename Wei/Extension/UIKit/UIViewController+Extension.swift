//
//  UIViewController+Extension.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/01.
//  Copyright © 2018 popshoot All rights reserved.
//

import UIKit

extension UIViewController {
    func embed(_ childViewController: UIViewController, to view: UIView) {
        childViewController.view.frame = view.bounds
        view.addSubview(childViewController.view)
        addChild(childViewController)
        childViewController.didMove(toParent: self)
    }
    
    func remove(_ childViewController: UIViewController) {
        childViewController.willMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParent()
    }
}

extension UIViewController {
    func showAlertController(
        title: String? = nil,
        message: String? = nil,
        actionTitle: String? = "OK",
        withCancel: Bool = false,
        cancelTitle: String = "Cancel",
        handler: ((UIAlertAction) -> ())? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: actionTitle, style: .default, handler: handler))
        
        if withCancel {
            alertController.addAction(UIAlertAction(title: cancelTitle, style: .cancel))
        }
        
        present(alertController, animated: true)
    }
    
    func showAlertController(withError error: Error, handler: ((UIAlertAction) -> ())? = nil) {
        let title = (error as? AlertConvertable)?.title
        let message = (error as? AlertConvertable)?.message
        showAlertController(title: title, message: message, handler: handler)
    }
}
