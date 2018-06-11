//
//  PresentationController.swift
//  Wei
//
//  Created by Ryosuke Fukuda on 2018/04/05.
//  Copyright © 2018 popshoot All rights reserved.
//

import UIKit

class PresentationController: UIPresentationController {
    
    var dimmingView: UIView!
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        dimmingView = UIView(frame: containerView?.frame ?? CGRect.zero)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return CGRect.zero
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize.zero
    }
    
    override func presentationTransitionWillBegin() {
        dimmingView.frame = containerView?.frame ?? CGRect.zero
        dimmingView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        dimmingView.alpha = 0
        containerView?.addSubview(dimmingView)
        
        presentedViewController.transitionCoordinator?.animate(
            alongsideTransition: { [weak self] _ in
                self?.dimmingView.alpha = 1
            },
            completion: nil
        )
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(
            alongsideTransition: { [weak self] _ in
                self?.dimmingView.alpha = 0
            },
            completion: nil
        )
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed { dimmingView.removeFromSuperview() }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed { dimmingView.removeFromSuperview() }
    }
}
