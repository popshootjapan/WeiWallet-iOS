//
//  UIScrollView+Rx.swift
//  Wei
//
//  Created by Ryosuke Fukuda on 2018/04/30.
//  Copyright © 2018 popshoot All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIScrollView {
    var scrollProgress: ControlEvent<CGFloat> {
        let contentSize = observe(CGSize.self, "contentSize")
            .map { $0 ?? CGSize.zero }
            .startWith(base.contentSize)
        
        let observable = Observable.combineLatest(contentSize, contentOffset) { size, offset -> CGFloat in
            return size.width > 0.0 ? offset.x / size.width : 0.0
        }
        
        return ControlEvent(events: observable)
    }
}
