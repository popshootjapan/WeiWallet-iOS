//
//  SelectAddressByPasteViewController.swift
//  Wei
//
//  Created by omatty198 on 2018/04/02.
//  Copyright © 2018年 popshoot All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SelectAddressByPasteViewController: UIViewController {

    var viewModel: SelectAddressByPasteViewModel!
    
    @IBOutlet private weak var pasteButton: UIButton!
    @IBOutlet private weak var invalidAddressView: UIView!
    @IBOutlet private weak var addressLabel: UILabel! {
        didSet {
            handleAddressLabel(with: nil)
        }
    }
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
}

private extension SelectAddressByPasteViewController {
    func bindViewModel() {
        let input = SelectAddressByPasteViewModel.Input(
            pasteByClipboardButtonDidTap: pasteButton.rx.tap.asDriver()
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
            .drive(invalidAddressView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output
            .isAddressValid
            .drive(onNext: { [weak self] isAddressValid in
                UINotificationFeedbackGenerator().successNotification()
                if !isAddressValid {
                    self?.handleAddressLabel(with: nil)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func pushSelectAmountViewController(with address: String) {
        handleAddressLabel(with: address)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: { [weak self] in
            let selectAmountViewController = SelectAmountViewController.make(address: address)
            self?.navigationController?.pushViewController(selectAmountViewController, animated: true)
        })
    }
    
    func handleAddressLabel(with address: String?) {
        if let address = address {
            addressLabel.text = address
            addressLabel.textColor = .black
        } else {
            addressLabel.text = "0x123456789"
            addressLabel.textColor = UIColor.wei.placeholder
        }
    }
}
