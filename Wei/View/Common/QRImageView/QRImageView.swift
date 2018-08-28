//
//  QRImageView.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/08/28.
//  Copyright © 2018 yz. All rights reserved.
//

import UIKit

final class QRImageView: UIView {
    
    @IBOutlet private weak var qrCodeImageView: UIImageView!
    
    static func instantiate(with qrcode: UIImage) -> QRImageView {
        let view = UINib.instantiateView(of: QRImageView.self)
        view.qrCodeImageView.image = qrcode
        return view
    }
}

extension QRImageView {
    func toImage() -> UIImage {
        let rect = bounds
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        
        let context: CGContext = UIGraphicsGetCurrentContext()!
        layer.render(in: context)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
