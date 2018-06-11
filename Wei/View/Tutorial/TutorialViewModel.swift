//
//  TutorialViewModel.swift
//  Wei
//
//  Created by omatty198 on 2018/04/21.
//  Copyright © 2018年 popshoot All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class TutorialViewModel: ViewModel {
    
    struct Input {
        let startButtonDidTap: Driver<Void>
        let nextButtonDidTap: Driver<Void>
        let scrollViewDidScroll: Driver<CGPoint>
    }
    
    struct Output {
        let dismissViewController: Driver<Void>
        let nextContentOffset: Driver<Void>
        let isLastPage: Driver<Bool>
        let currentPage: Driver<Int>
    }
    
    func build(input: Input) -> Output {
        let currentPage = input
            .scrollViewDidScroll
            .map { offset -> Int in
                let offset: CGFloat = offset.x / TutorialTopView.size().width
                let page = TutorialTopView.Page(rawValue: Int(offset)) ?? .first
                return page.rawValue
            }
            .startWith(0)
        
        let isLastPage = currentPage
            .map { $0 == TutorialTopView.Page.third.rawValue }
        
        return Output(
            dismissViewController: input.startButtonDidTap,
            nextContentOffset: input.nextButtonDidTap,
            isLastPage: isLastPage,
            currentPage: currentPage
        )
    }
}

