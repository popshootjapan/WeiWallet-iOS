//
//  GasSettingViewController.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/09/11.
//  Copyright © 2018 yz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class GasSettingViewController: UIViewController {
    
    var viewModel: GasSettingViewModel!
    
    @IBOutlet private weak var gasPriceLabel: UILabel!
    @IBOutlet private weak var slider: UISlider!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let output = viewModel.build(input: GasSettingViewModel.Input(
            sliderValue: slider.rx.value.asDriver()
        ))
        
        slider.value = Float(output.initialGasPrice) / 100
        
        output
            .updatedGasPrice
            .startWith(output.initialGasPrice)
            .drive(onNext: { [weak self] gasPrice in
                self?.gasPriceLabel.text = "\(gasPrice) GWei"
            })
            .disposed(by: disposeBag)
    }
}
