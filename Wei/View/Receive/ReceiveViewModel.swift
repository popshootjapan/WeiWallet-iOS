//
//  ReceiveViewModel.swift
//  Wei
//
//  Created by omatty198 on 2018/04/04.
//  Copyright © 2018年 popshoot All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ReceiveViewModel: InjectableViewModel {
    
    typealias Dependency = (
        WalletManagerProtocol,
        QRCoderProtocol
    )
    
    private let walletManager: WalletManagerProtocol
    private let qrCoder: QRCoderProtocol
    
    init(dependency: Dependency) {
        (walletManager, qrCoder) = dependency
    }
    
    struct Input {
        let copyAddressButtonDidTap: Driver<Void>
        let closeButtonDidTap: Driver<Void>
        let shareQRCodeButtonDidTap: Driver<Void>
    }
    
    struct Output {
        let copyByClipboard: Driver<String>
        let address: Driver<String>
        let qrCodeImage: Driver<UIImage>
        let dismissViewController: Driver<Void>
        let presentActivityController: Driver<UIImage>
    }
    
    func build(input: Input) -> Output {
        let address = Driver.just(walletManager.address())
        
        let qrCodeImage = address
            .map(qrCoder.generate)
            .flatMap(Driver.from)
        
        let copyByClipboard = input.copyAddressButtonDidTap
            .throttle(3.0, latest: false)
            .withLatestFrom(address)
        
        return Output(
            copyByClipboard: copyByClipboard,
            address: address,
            qrCodeImage: qrCodeImage,
            dismissViewController: input.closeButtonDidTap,
            presentActivityController: input.shareQRCodeButtonDidTap
                .withLatestFrom(qrCodeImage)
        )
    }
}
