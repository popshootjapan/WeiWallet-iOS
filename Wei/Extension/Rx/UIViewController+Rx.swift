//
//  UIViewController+Rx.swift
//  Wei
//
//  Created by yuzushioh on 2018/03/14.
//  Copyright © 2018 popshoot. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    private func controlEvent(for selector: Selector) -> ControlEvent<Void> {
        return ControlEvent(events: sentMessage(selector).map { _ in })
    }
    
    var viewWillAppear: ControlEvent<Void> {
        return controlEvent(for: #selector(UIViewController.viewWillAppear))
    }
    
    var viewDidAppear: ControlEvent<Void> {
        return controlEvent(for: #selector(UIViewController.viewDidAppear))
    }
}

extension Reactive where Base: UIViewController {
    var showError: Binder<Error> {
        return Binder(base) { base, error in
            base.showAlertController(withError: error)
        }
    }
}
