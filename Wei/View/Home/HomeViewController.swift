//
//  HomeViewController.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/01.
//  Copyright © 2018 popshoot All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {
    
    var viewModel: HomeViewModel!
    
    @IBOutlet private weak var myWalletContainerView: UIView!
    @IBOutlet private weak var receiveButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        embedMyWalletViewController()
    }
    
    private func bindViewModel() {
        let input = HomeViewModel.Input(
            receiveButtonDidTap: receiveButton.rx.tap.asDriver()
        )
        
        let output = viewModel.build(input: input)
        
        output
            .presentReceiveViewController
            .drive(onNext: { [weak self] in
                self?.presentReceiveViewController()
            })
            .disposed(by: disposeBag)
    }
    
    private func embedMyWalletViewController() {
        let viewController = MyWalletViewController.make()
        embed(viewController, to: myWalletContainerView)
    }
    
    private func presentReceiveViewController() {
        let viewController = ReceiveViewController.make()
        present(viewController, animated: true)
    }
}

extension HomeViewController: ControllableNavigationBar {
    func setNavigationBarHiddenOnDisplay() -> Bool {
        return true
    }
}
