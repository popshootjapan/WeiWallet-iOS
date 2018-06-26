//
//  SuggestBackupViewController.swift
//  Wei
//
//  Created by omatty198 on 2018/05/14.
//  Copyright © 2018年 popshoot All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SuggestBackupViewController: UIViewController {
    
    var viewModel: SuggestBackupViewModel!
    
    @IBOutlet private weak var backupButton: UIButton!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var messageLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    
    static func size() -> CGSize {
        return CGSize(width: 316, height: 500)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = R.string.localizable.suggestBackupMessage()
        bindViewModel()
    }
    
    func bindViewModel() {
        let input = SuggestBackupViewModel.Input(
            backupButtonDidTap: backupButton.rx.tap.asDriver(),
            closeButtonDidTap: closeButton.rx.tap.asDriver()
        )
        
        let output = viewModel.build(input: input)
        
        output
            .presentBackupViewController
            .drive(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: { () in
                    let viewController = BackupViewController.make()
                    let navigationController = NavigationController(rootViewController: viewController)
                    AppDelegate.rootViewController.present(navigationController, animated: true)
                })
            })
            .disposed(by: disposeBag)
        
        output
            .dismissViewController
            .drive(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension SuggestBackupViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DialogPresentationController(presentedViewController: presented, presenting: presenting, size: SuggestBackupViewController.size())
    }
}
