//
//  MnemonicWordViewCell.swift
//  Wei
//
//  Created by omatty198 on 2018/05/21.
//  Copyright © 2018年 popshoot All rights reserved.
//

import UIKit

final class MnemonicWordViewCell: UICollectionViewCell, InputAppliable {
    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var mnemonicWordLabel: UILabel!

    typealias Input = MnemonicWord
    
    func apply(input: Input) {
        numberLabel.text = (input.row + 1).description
        mnemonicWordLabel.text = input.text
    }
}
