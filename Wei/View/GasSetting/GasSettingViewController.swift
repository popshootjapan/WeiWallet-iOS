//
//  GasSettingViewController.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/09/11.
//  Copyright © 2018 yz. All rights reserved.
//

import UIKit

final class GasSettingViewController: UIViewController {
    
    var viewModel: GasSettingViewModel!
    
    @IBOutlet private weak var gasPriceLabel: UILabel!
    @IBOutlet private weak var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
