//
//  TutorialTopView.swift
//  Wei
//
//  Created by omatty198 on 2018/04/21.
//  Copyright © 2018年 yz. All rights reserved.
//

import UIKit

final class TutorialTopView: UIView {
    enum Page: Int {
        case first
        case second
        case third
        
        func image() -> UIImage {
            switch self {
            case .first:
                return UIImage(named: "tutorial_first")!
            case .second:
                return UIImage(named: "tutorial_second")!
            case .third:
                return UIImage(named: "tutorial_third")!
            }
        }
        
        func title() -> String {
            switch self {
            case .first:
                return "ようこそWei Walletへ！"
            case .second:
                return "スムーズな受取と送金"
            case .third:
                return "Wei Walletは安全です"
            }
        }
        
        func description() -> String {
            switch self {
            case .first:
                return "あなたのウォレットが作成されました。"
            case .second:
                return "受取や送金は素早く完了します。\nまた、Wei Walletは余計な手数料を取りません。"
            case .third:
                return "バックアップを取ることでウォレット内のイーサリアムはいつでも復元することができます。"
            }
        }
        
        func nextWidth() -> CGFloat {
            return TutorialTopView.size().width * CGFloat(rawValue + 1)
        }
        
        static var numberOfPages: Int {
            return Page.third.rawValue + 1
        }
    }

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    private var page: Page!
    
    static func size() -> CGSize {
        return CGSize(width: 316, height: 440)
    }
    
    static func create(page: Page) -> TutorialTopView {
            let view = TutorialTopView.instantiate(withOwner: nil)
            view.configure(page: page)
            return view
    }
    
    func configure(page: Page) {
        self.page = page
        imageView.image = page.image()
        titleLabel.text = page.title()
        descriptionLabel.text = page.description()
    }
}
