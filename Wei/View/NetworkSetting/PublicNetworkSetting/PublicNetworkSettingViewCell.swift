//
//  NetworkSettingViewCell.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/07/06.
//  Copyright © 2018 yz. All rights reserved.
//

import UIKit

final class PublicNetworkSettingViewCell: UITableViewCell, InputAppliable {
    
    @IBOutlet private weak var nameLabel: UILabel!
    
    typealias Input = (Network, Bool)
    
    func apply(input: Input) {
        let (network, selectedNetwork) = input
        nameLabel.text = network.name
        
        let font = selectedNetwork ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 16)
        nameLabel.font = font
        
        let color = selectedNetwork ? UIColor.wei.success : UIColor.wei.black
        nameLabel.textColor = color
    }
}
