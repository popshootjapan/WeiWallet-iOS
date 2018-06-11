//
//  BackupViewModel.swift
//  Wei
//
//  Created by omatty198 on 2018/05/13.
//  Copyright © 2018年 popshoot All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class BackupViewModel: InjectableViewModel {
    
    typealias Dependency = (
        ApplicationStoreProtocol
    )
    
    private var applicationStore: ApplicationStoreProtocol
    
    init(dependency: Dependency) {
        (applicationStore) = dependency
    }
    
    struct Input {
        let viewWillAppear: Driver<Void>
        let confirmButtonDidTap: Driver<Void>
        let closeButtonDidTap: Driver<Void>
        let backupTrigger: Driver<Void>
    }
    
    struct Output {
        let mnemonicWords: Driver<[MnemonicWord]>
        let presentConfirmAlert: Driver<Void>
        let dismissViewController: Driver<Void>
        let backup: Driver<Void?>
    }
    
    func build(input: Input) -> Output {
        guard let mnemonicWords = applicationStore.mnemonic?.split(separator: " ") else {
            fatalError()
        }
        
        let mnemonicWordsDriver = input.viewWillAppear
            .map { mnemonicWords.enumerated().map { MnemonicWord(row: $0.offset, text: String($0.element)) } }
        
        let backup = input.backupTrigger
            .map { [weak self] _ in
                self?.applicationStore.isAlreadyBackup = true
            }
        
        return Output(
            mnemonicWords: mnemonicWordsDriver,
            presentConfirmAlert: input.confirmButtonDidTap,
            dismissViewController: input.closeButtonDidTap,
            backup: backup
        )
    }
}

