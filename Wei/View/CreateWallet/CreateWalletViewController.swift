//
//  CreateWalletViewController.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/01.
//  Copyright © 2018 popshoot All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class CreateWalletViewController: UIViewController {
    
    var viewModel: CreateWalletViewModel!
    
    @IBOutlet private weak var createWalletButton: UIButton!
    @IBOutlet private weak var restoreButton: UIButton!
    @IBOutlet private weak var showServiceTermsButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            hideIfNeccesary(titleLabel)
        }
    }
    @IBOutlet private weak var textView: UITextView! {
        didSet {
            textView.text = R.string.localizable.createWalletMessage()
            hideIfNeccesary(textView)
        }
    }
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = CreateWalletViewModel.Input(
            createWalletButtonDidTap: createWalletButton.rx.tap.asDriver(),
            restoreButtonDidTap: restoreButton.rx.tap.asDriver(),
            showServiceTermsButtonDidTap: showServiceTermsButton.rx.tap.asDriver()
        )
        
        let output = viewModel.build(input: input)
        
        output
            .presentAgreeServiceTermViewController
            .drive(onNext: { _ in
                UIApplication.shared.open(URL.wei.terms)
            })
            .disposed(by: disposeBag)
        
        output
            .pushRestoreWalletViewController
            .drive(onNext: { [weak self] in
                self?.pushRestoreWalletViewController()
            })
            .disposed(by: disposeBag)
        
        output
            .didGenerateWallet
            .drive(onNext: { [weak self] in
                self?.dismissAndPresentTutorialViewController()
            })
            .disposed(by: disposeBag)
        
        output
            .isGeneratingWallet
            .drive(rx.isHUDAnimating)
            .disposed(by: disposeBag)
        
        output.error
            .drive(rx.showError)
            .disposed(by: disposeBag)
    }
    
    private func hideIfNeccesary(_ view: UIView) {
        if UIDevice.wei.is3_5Inch() || UIDevice.wei.is4Inch() || UIDevice.wei.isPad() {
            view.isHidden = true
        }
    }
    
    private func pushRestoreWalletViewController() {
        let viewController = RestoreWalletViewController.make()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func dismissAndPresentTutorialViewController() {
        dismiss(animated: true, completion: {
            let viewController = TutorialViewController.make()
            AppDelegate.rootViewController.present(viewController, animated: true)
        })
    }
}

extension CreateWalletViewController: ControllableNavigationBar {
    func setNavigationBarHiddenOnDisplay() -> Bool {
        return true
    }
}
