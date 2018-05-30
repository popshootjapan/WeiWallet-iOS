//
//  InjectableViewModel.swift
//  Wei
//
//  Created by yuzushioh on 2018/03/14.
//  Copyright © 2018 popshoot. All rights reserved.
//

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    func build(input: Input) -> Output
}

typealias InjectableViewModel = ViewModel & Injectable
