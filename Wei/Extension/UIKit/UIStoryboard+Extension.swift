//
//  UIStoryboard+Extension.swift
//  Wei
//
//  Created by yuzushioh on 2018/03/18.
//  Copyright © 2018 popshoot All rights reserved.
//

import UIKit

extension UIStoryboard {
    static func instantiateViewController<ViewController: UIViewController>(of type: ViewController.Type, withName name: String = String(describing: ViewController.self)) -> ViewController {
        
        let bundle = Bundle(for: ViewController.self)
        let storyboard = UIStoryboard(name: name, bundle: bundle)
        
        guard let viewController = storyboard.instantiateInitialViewController() as? ViewController else {
            fatalError("Could not find the specified view controller in the storyboard.")
        }
        
        return viewController
    }
}

extension UINib {
    static func instantiateView<View: UIView>(of type: View.Type, withName name: String = String(describing: View.self)) -> View {
        let bundle = Bundle(for: View.self)
        let nib = UINib(nibName: name, bundle: bundle)
        
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? View else {
            fatalError("Could not find the specified view in the nib.")
        }
        
        return view
    }
}
