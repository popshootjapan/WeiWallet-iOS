//
//  DialogPresentationController.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/20.
//  Copyright © 2018 popshoot All rights reserved.
//

import UIKit

final class DialogPresentationController: PresentationController {
    
    let size: CGSize
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, size: CGSize) {
        self.size = size
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        presentedView?.layer.cornerRadius = 4
        presentedView?.layer.shadowColor = UIColor.black.cgColor
        presentedView?.layer.shadowOffset = CGSize(width: 0, height: 2)
        presentedView?.layer.shadowRadius = 4
        presentedView?.layer.shadowOpacity = 0.5
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else {
            return CGRect.zero
        }
        
        return CGRect(
            x: (containerView.frame.size.width - size.width) / 2,
            y: (containerView.frame.size.height - size.height) / 2,
            width: size.width,
            height: size.height
        )
    }
    
    override func containerViewWillLayoutSubviews() {
        guard let containerView = containerView else {
            return
        }
        
        dimmingView.frame = containerView.bounds
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
}
