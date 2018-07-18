//
//  UpdateServiceTermsViewModel.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/07/17.
//  Copyright © 2018 yz. All rights reserved.
//

import RxSwift
import RxCocoa

final class UpdateServiceTermsViewModel: InjectableViewModel {
    
    typealias Dependency = (
        RegistrationRepositoryProtocol
    )
    
    private let repository: RegistrationRepositoryProtocol
    
    init(dependency: Dependency) {
        (repository) = dependency
    }
    
    struct Input {
        let agreeButtonDidTap: Driver<Void>
        let termsButtonDidTap: Driver<Void>
    }
    
    struct Output {
        let isExecuting: Driver<Bool>
        let error: Driver<Error>
        let dismissViewController: Driver<Void>
        let showServiceTerm: Driver<Void>
    }
    
    func build(input: Input) -> Output {
        let agreeAction = input.agreeButtonDidTap.flatMap { [weak self] _ -> Driver<Action<Void>> in
            guard let weakSelf = self else {
                return Driver.empty()
            }
            
            let source = weakSelf.repository.agreeServiceTerms()
            return Action.makeDriver(source)
        }
        
        return Output(
            isExecuting: agreeAction.isExecuting,
            error: agreeAction.error,
            dismissViewController: agreeAction.elements,
            showServiceTerm: input.termsButtonDidTap
        )
    }
}
