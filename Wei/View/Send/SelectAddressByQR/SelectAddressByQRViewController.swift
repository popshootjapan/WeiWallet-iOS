//
//  SelectAddressByQRViewController.swift
//  Wei
//
//  Created by omatty198 on 2018/04/02.
//  Copyright © 2018年 popshoot All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SelectAddressByQRViewController: UIViewController {
    
    var viewModel: SelectAddressByQRViewModel!
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var warningTextView: UITextView! {
        didSet {
            warningTextView.text = R.string.localizable.selectAddressWarningText()
        }
    }
    
    private let disposeBag = DisposeBag()
    private let address = PublishSubject<String>()
    
    lazy var qrCoder: QRCoder = {
       return QRCoder(delegate: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureQRCodeView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        qrCoder.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        qrCoder.stopRunning()
    }
    
    func bindViewModel() {
        let input = SelectAddressByQRViewModel.Input(
            address: address.asDriver(onErrorDriveWith: .empty())
        )
        
        let output = viewModel.build(input: input)
        
        output
            .pushSelectAmountViewController
            .drive(onNext: { [weak self] address in
                self?.pushSelectAmountViewController(with: address)
            })
            .disposed(by: disposeBag)
        
        output
            .isAddressValid
            .drive(onNext: { [weak self] in
                self?.showAlertController(
                    title: R.string.localizable.alertSelectAddressByQRInvalidAddressTitle(),
                    message: R.string.localizable.alertSelectAddressByQRInvalidAddressMessage()
                )
            })
            .disposed(by: disposeBag)
        
    }
    
    private func configureQRCodeView() {
        QRCoder.requestAccess { [weak self] granted in
            guard granted else {
                self?.showSettingsAlertController()
                return
            }
            self?.configureQRCoder()
        }
    }
    
    private func configureQRCoder() {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.qrCoder.configure(on: weakSelf.containerView)
            weakSelf.qrCoder.startRunning()
        }
    }
    
    private func showSettingsAlertController() {
        DispatchQueue.main.async { () in
            AppDelegate.rootViewController.presentedViewController?.showAlertController(
                title: R.string.localizable.commonCameraAccessTitle(),
                message: R.string.localizable.commonCameraAccessDescription(),
                actionTitle: "OK",
                withCancel: true,
                cancelTitle: R.string.localizable.commonCameraAccessCancel(),
                handler: { _ in
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL)
                    }
            })
        }
    }
    
    private func pushSelectAddressByPasteViewController() {
        let viewController = SelectAddressByPasteViewController.make()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func pushSelectAmountViewController(with address: String) {
        let selectAmountViewController = SelectAmountViewController.make(address: address)
        navigationController?.pushViewController(selectAmountViewController, animated: true)
    }
}

extension SelectAddressByQRViewController: QRCoderDelegate {
    func qrCoder(_ qrCoder: QRCoder, didDetectQRCode url: String) {
        address.onNext(url)
    }
}
