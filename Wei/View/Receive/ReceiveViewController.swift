//
//  ReceiveViewController.swift
//  Wei
//
//  Created by omatty198 on 2018/04/04.
//  Copyright © 2018年 yz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ReceiveViewController: UIViewController {

    var viewModel: ReceiveViewModel!
    
    @IBOutlet private weak var qrImageView: UIImageView!
    @IBOutlet private weak var copyAddressButton: UIButton!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var copyNoticeView: UIView!

    private let topMargin: CGFloat = 64
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        bindViewModel()
    }
}

private extension ReceiveViewController {
    func bindViewModel() {
        let input = ReceiveViewModel.Input(
            copyAddressButtonDidTap: copyAddressButton.rx.tap.asDriver(),
            closeButtonDidTap: closeButton.rx.tap.asDriver()
        )
        
        let output = viewModel.build(input: input)
        output
            .copyByClipboard
            .drive(onNext: { [weak self] address in
                self?.animateCopyNoticeView()
                UINotificationFeedbackGenerator().successNotification()
                UIPasteboard.general.string = address
            })
            .disposed(by: disposeBag)
        
        output
            .address
            .drive(addressLabel.rx.text)
            .disposed(by: disposeBag)
        
        output
            .qrCodeImage
            .drive(qrImageView.rx.image)
            .disposed(by: disposeBag)
        
        output
            .dismissViewController
            .drive(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func animateCopyNoticeView() {
        copyNoticeView.isHidden = false
        slideUp() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { [weak self] in
                self?.slideDown() { [weak self] in
                    self?.copyNoticeView.isHidden = true
                }
            })
        }
    }
    
    func slideUp(completion: @escaping () -> Void) {
        let baseHeight = UIScreen.main.bounds.height - topMargin - view.safeAreaInsets.bottom
        copyNoticeView.frame.origin.y = baseHeight
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.0,
            options: .curveLinear,
            animations: {
                self.copyNoticeView.frame.origin.y = baseHeight - self.copyNoticeView.frame.height
            },
            completion: { _ in
                completion()
            }
        )
    }
    
    func slideDown(completion: @escaping () -> Void) {
        let baseHeight = UIScreen.main.bounds.height - topMargin
        copyNoticeView.frame.origin.y = baseHeight - view.safeAreaInsets.bottom - copyNoticeView.frame.height
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0.3,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.0,
            options: .curveLinear,
            animations: {
                self.copyNoticeView.frame.origin.y = baseHeight
            },
            completion: { _ in
                completion()
            }
        )
    }
}

extension ReceiveViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let screenHeight = UIScreen.main.bounds.height
        return ModalPresentationController(presentedViewController: presented, presenting: presenting, height: screenHeight - topMargin)
    }
}
