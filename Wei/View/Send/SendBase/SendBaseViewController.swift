//
//  SendBaseViewController.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/07.
//  Copyright © 2018 popshoot All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SendBaseViewController: UIViewController {
    
    var viewModel: SendBaseViewModel!
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var cancelButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        embedSwipableViewController()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = SendBaseViewModel.Input(
            cancelButtonDidTap: cancelButton.rx.tap.asDriver()
        )
        
        let output = viewModel.build(input: input)
        
        output
            .dismissViewController
            .drive(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func embedSwipableViewController() {
        let viewController = SwipableViewController.make(
            viewControllers: [SelectAddressByQRViewController.make(), SelectAddressByPasteViewController.make()],
            titles: [R.string.localizable.pageQRCode(), R.string.localizable.pageCopyAddress()]
        )
        
        viewController.navigationItem.title = navigationItem.title
        viewController.navigationItem.leftBarButtonItem = navigationItem.leftBarButtonItem
        
        let navigationController = NavigationController(rootViewController: viewController)
        embed(navigationController, to: containerView)
    }
}

extension SendBaseViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let screenHeight = UIScreen.main.bounds.height
        return ModalPresentationController(presentedViewController: presented, presenting: presenting, height: screenHeight - 64)
    }
}
