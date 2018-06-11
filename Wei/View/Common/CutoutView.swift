//
//  CutoutView.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/19.
//  Copyright © 2018 popshoot All rights reserved.
//

import UIKit

@IBDesignable
class CutoutView: UIView {
    
    @IBInspectable
    var fillColor: UIColor = UIColor.clear
    
    override func draw(_ rect: CGRect) {
        let roundRectLength = CGFloat(270)
        
        let outterFill = UIBezierPath(rect: rect)
        let portalRect = CGRect(
            x: (rect.width - roundRectLength) / 2,
            y: 130,
            width: roundRectLength,
            height: roundRectLength
        )
        
        fillColor.setFill()
        
        let portal = UIBezierPath(roundedRect: portalRect, cornerRadius: 6.0)
        outterFill.append(portal)
        outterFill.usesEvenOddFillRule = true
        outterFill.fill()
    }
}

