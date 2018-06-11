//
//  EmptyViewManager.swift
//  Wei
//
//  Created by Ryosuke Fukuda on 2018/05/23.
//  Copyright © 2018 popshoot All rights reserved.
//

import UIKit

final class EmptyViewManager {
    
    private let emptyView: UIView
    private let container: UIView
    
    init(emptyView: UIView, container: UIView) {
        self.emptyView = emptyView
        self.container = container
    }
    
    func showEmptyView() {
        emptyView.removeFromSuperview()
        emptyView.frame = container.bounds
        container.addSubview(emptyView)
    }
    
    func removeEmptyView() {
        emptyView.removeFromSuperview()
    }
}
