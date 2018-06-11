//
//  HUD+Rx.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/22.
//  Copyright © 2018 popshoot All rights reserved.
//

import SVProgressHUD
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    var isHUDAnimating: Binder<Bool> {
        return Binder(base) { _, animating in
            if animating {
                SVProgressHUD.show()
            } else {
                SVProgressHUD.dismiss()
            }
        }
    }
}
