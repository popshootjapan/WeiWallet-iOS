//
//  AdjustGasPriceViewController.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/06/06.
//  Copyright © 2018 yz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class AdjustGasPriceViewController: UIViewController {
    
    var viewModel: AdjustGasPriceViewModel!
    
    @IBOutlet private weak var gasPriceSlider: UISlider!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let output = viewModel.build(input: .init(
            updatedGasPrice: gasPriceSlider.rx.value.asDriver().map(Int.init)
        ))
        
        output
            .gasPrice
            .map(Float.init)
            .drive(gasPriceSlider.rx.value)
            .disposed(by: disposeBag)
    }
}
