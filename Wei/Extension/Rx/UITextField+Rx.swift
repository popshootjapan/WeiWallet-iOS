//
//  UITextField+Rx.swift
//  Wei
//
//  Created by Ryosuke Fukuda on 2018/05/23.
//  Copyright © 2018 popshoot All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UITextField {
    var trimmedText: ControlProperty<String?> {
        let value = text.map { $0?.trimmingCharacters(in: .whitespaces) }
        let bindingObserver = Binder(base) { (textView, text: String?) in
            if textView.text != text {
                textView.text = text?.trimmingCharacters(in: .whitespaces)
            }
        }
        return ControlProperty(values: value, valueSink: bindingObserver)
    }
}
