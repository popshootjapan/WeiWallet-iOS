//
//  RestoreWalletViewController.swift
//  Wei
//
//  Created by yuzushioh on 2018/05/22.
//  Copyright © 2018 popshoot All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class RestoreWalletViewController: UIViewController {
    
    var viewModel: RestoreWalletViewModel!
    
    @IBOutlet private var mnemonicWordTextFields: [UITextField]!
    @IBOutlet private weak var confirmButton: UIBarButtonItem!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var messageLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    private var isOpenedKeyboard: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = R.string.localizable.restoreWalletMessage()
        bindViewModel()
        bindKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mnemonicWordTextFields.first?.becomeFirstResponder()
    }
    
    private func bindViewModel() {
        let output = viewModel.build(input: .init(
            words: mnemonicWordTextFields.map { $0.rx.trimmedText.orEmpty.asDriver() },
            confirmButtonDidTap: confirmButton.rx.tap.asDriver()
        ))
        
        output
            .isConfirmButtonEnabled
            .drive(confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output
            .isExecuting
            .drive(rx.isHUDAnimating)
            .disposed(by: disposeBag)
        
        output
            .dismissViewController
            .drive(onNext: { [weak self] in
                self?.showAlertController(message: "ウォレットを復元しました") { [weak self] _ in
                    self?.dismiss(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        output
            .invalidMnemonic
            .drive(onNext: { [weak self] in
                self?.showAlertController(message: "バックアップの単語が間違っています")
            })
            .disposed(by: disposeBag)
    }
    
    private func bindKeyboard() {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification).asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] notification in
                self?.keyboardWillBeShown(notification: notification)
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification).asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] notification in
                self?.keyboardWillBeHidden(notification: notification)
            })
            .disposed(by: disposeBag)
    }
    
    private func keyboardWillBeShown(notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            guard let userInfo = notification.userInfo,
                let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue,
                !self.isOpenedKeyboard else {
                    return
            }
            
            self.isOpenedKeyboard = true
            
            let autoCorrectSpaceHeight = CGFloat(44)
            let convertedKeyboardFrame = self.scrollView.superview?.convert(keyboardFrame, to: nil)
            let contentInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: convertedKeyboardFrame!.size.height + autoCorrectSpaceHeight, right: 0)
            
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
        }
    }
    
    private func keyboardWillBeHidden(notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            guard let userInfo = notification.userInfo,
                let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue,
                self.isOpenedKeyboard else {
                    return
            }
            
            self.isOpenedKeyboard = false
            
            UIView.beginAnimations("ResizeForKeyboard", context: nil)
            UIView.setAnimationDuration(animationDuration)
            self.scrollView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
            self.scrollView.scrollIndicatorInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
            UIView.commitAnimations()
        }
    }
}
