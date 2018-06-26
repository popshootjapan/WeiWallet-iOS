//
//  BackupViewController.swift
//  Wei
//
//  Created by omatty198 on 2018/05/13.
//  Copyright © 2018年 popshoot All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class BackupViewController: UIViewController {
    
    var viewModel: BackupViewModel!
    
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var confirmButton: UIBarButtonItem!
    @IBOutlet private var backupMessageLabel: UILabel!
    
    private lazy var closeButton: UIBarButtonItem = {
        return UIBarButtonItem(title: R.string.localizable.commonClose(), style: .plain, target: nil, action: nil)
    }()
    
    private let backupTrigger = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backupMessageLabel.text = R.string.localizable.backupMessage()
        addCloseButtonWhenExistPresentingViewController()
        bindViewModel()
    }
    
    func bindViewModel() {
        let input = BackupViewModel.Input(
            viewWillAppear: rx.viewWillAppear.asDriver(),
            confirmButtonDidTap: confirmButton.rx.tap.asDriver(),
            closeButtonDidTap: closeButton.rx.tap.asDriver(),
            backupTrigger: backupTrigger.asDriver(onErrorDriveWith: .empty())
        )
        
        let output = viewModel.build(input: input)
        
        output
            .mnemonicWords
            .drive(collectionView.rx.items(cellType: MnemonicWordViewCell.self))
            .disposed(by: disposeBag)

        output
            .presentConfirmAlert
            .drive(onNext: { [weak self] in
                self?.showConfirmAlert()
            })
            .disposed(by: disposeBag)
        
        output
            .dismissViewController
            .drive(onNext: { [weak self] in
                self?.dismissOrPopViewController()
            })
            .disposed(by: disposeBag)
        
        output
            .backup
            .drive(onNext: { [weak self] _ in
                self?.dismissOrPopViewController()
            })
            .disposed(by: disposeBag)
    }
    
    private func addCloseButtonWhenExistPresentingViewController() {
        if presentingViewController != nil {
            navigationItem.leftBarButtonItem = closeButton
        }
    }
    
    private func showConfirmAlert() {
        showAlertController(
            title: R.string.localizable.alertBackupTitle(),
            message: R.string.localizable.alertBackupMessage(),
            actionTitle: "OK",
            handler: { [weak self] _ in
                self?.backupTrigger.onNext(())
        })
    }
    
    private func dismissOrPopViewController() {
        if presentingViewController == nil {
            // To setting vc
            navigationController?.popViewController(animated: true)
        } else {
            // To suggest backup vc
            dismiss(animated: true)
        }
    }
}

extension BackupViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / 2, height: 64.0)
    }
}
