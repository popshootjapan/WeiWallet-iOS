//
//  ModalPresentationController.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/20.
//  Copyright © 2018 popshoot All rights reserved.
//

import UIKit

final class ModalPresentationController: PresentationController {
    
    private let height: CGFloat
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, height: CGFloat) {
        self.height = height
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else {
            return CGRect.zero
        }
        
        let viewSize = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView.bounds.size)
        return CGRect(x: 0, y: containerView.frame.height - height, width: viewSize.width, height: viewSize.height)
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        guard let containerView = containerView else {
            return CGSize.zero
        }
        
        return CGSize(width: containerView.frame.width, height: height)
    }
}
