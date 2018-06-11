//
//  AgreeServiceTermsViewController.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/22.
//  Copyright © 2018 popshoot All rights reserved.
//

import UIKit

final class AgreeServiceTermsViewController: UIViewController {
    
    @IBOutlet private weak var agreeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
    
    @IBAction private func agreeButtonDidTap(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension AgreeServiceTermsViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let size = CGSize(width: 316, height: 500)
        return DialogPresentationController(presentedViewController: presented, presenting: presenting, size: size)
    }
}
