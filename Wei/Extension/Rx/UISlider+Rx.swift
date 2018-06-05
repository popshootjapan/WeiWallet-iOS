//
//  UISlider+Rx.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/06/06.
//  Copyright © 2018 yz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UISlider {
    
    var didEndSliding: ControlEvent<Void> {
        return controlEvent([.touchUpInside, .touchUpOutside])
    }
}
