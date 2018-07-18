//
//  UpdateServiceTermsViewController.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/07/17.
//  Copyright © 2018 yz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class UpdateServiceTermsViewController: UIViewController {
    
    var viewModel: UpdateServiceTermsViewModel!
    
    @IBOutlet private weak var agreeButton: UIButton!
    @IBOutlet private weak var termsButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let output = viewModel.build(input: UpdateServiceTermsViewModel.Input(
            agreeButtonDidTap: agreeButton.rx.tap.asDriver(),
            termsButtonDidTap: termsButton.rx.tap.asDriver()
        ))
        
        output
            .dismissViewController
            .drive(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        output
            .error
            .drive(onNext: { [weak self] error in
                self?.showAlertController(withError: error)
            })
            .disposed(by: disposeBag)
        
        output
            .showServiceTerm
            .drive(onNext: { _ in
                UIApplication.shared.open(URL.wei.terms)
            })
            .disposed(by: disposeBag)
        
        output
            .isExecuting
            .drive(rx.isHUDAnimating)
            .disposed(by: disposeBag)
    }
}

extension UpdateServiceTermsViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DialogPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            size: CGSize(width: 316, height: 500)
        )
    }
}
