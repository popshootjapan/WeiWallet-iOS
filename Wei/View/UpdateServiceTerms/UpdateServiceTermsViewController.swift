//
//  UpdateServiceTermsViewController.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/07/17.
//  Copyright © 2018 yz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class UpdateServiceTermsViewController: UIViewController {
    
    var viewModel: UpdateServiceTermsViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension UpdateServiceTermsViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DialogPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            size: CGSize(width: 316, height: 500)
        )
    }
}
