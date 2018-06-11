//
//  UITableView+Rx.swift
//  Wei
//
//  Created by Ryosuke Fukuda on 2018/04/14.
//  Copyright © 2018 popshoot All rights reserved.
//

import UIKit
import RxSwift

extension Reactive where Base: UITableView {
    func items<S: Sequence, Cell: UITableViewCell, O: ObservableType>(cellIdentifier: String = String(describing: Cell.self), cellType: Cell.Type) -> (O) -> (Disposable)
        where O.E == S, Cell: InputAppliable, Cell.Input == S.Iterator.Element {
            return { source in
                let binder: (Int, Cell.Input, Cell) -> Void = { $2.apply(input: $1) }
                return self.items(cellIdentifier: cellIdentifier, cellType: cellType)(source)(binder)
            }
    }
}
