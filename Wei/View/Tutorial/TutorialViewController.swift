//
//  TutorialViewController.swift
//  Wei
//
//  Created by omatty198 on 2018/04/21.
//  Copyright © 2018年 popshoot All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class TutorialViewController: UIViewController {
    
    var viewModel: TutorialViewModel!
    
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    private var tutorialTopView: TutorialTopView!
    private let disposeBag = DisposeBag()
    
    static func size() -> CGSize {
        return CGSize(width: 316, height: 500)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScrollView()
        confiugrePage()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = TutorialViewModel.Input(
            startButtonDidTap: startButton.rx.tap.asDriver(),
            nextButtonDidTap: nextButton.rx.tap.asDriver(),
            scrollViewDidScroll: scrollView.rx.contentOffset.asDriver()
        )
        
        let output = viewModel.build(input: input)
        
        output
            .dismissViewController
            .drive(onNext: { [weak self] in
                self?.dismiss(animated: false)
            })
            .disposed(by: disposeBag)
        
        output
            .nextContentOffset
            .drive(onNext: { [weak self] in
                self?.nextContentOffset()
            })
            .disposed(by: disposeBag)
        
        output
            .isLastPage
            .drive(onNext: { [weak self] isLastPage in
                self?.startButton.isHidden = !isLastPage
                self?.nextButton.isHidden = isLastPage
            })
            .disposed(by: disposeBag)
        
        output
            .currentPage
            .drive(pageControl.rx.currentPage)
            .disposed(by: disposeBag)
    }
    
    private func nextContentOffset() {
        let page = TutorialTopView.Page(rawValue: pageControl.currentPage) ?? .first
        let point = CGPoint(x: page.nextWidth(), y: 0)
        scrollView.setContentOffset(point, animated: true)
    }
    
    private func confiugrePage() {
        let pages: [TutorialTopView.Page] = [.first, .second, .third]
        
        pages
            .enumerated()
            .forEach { index, page in
                tutorialTopView = TutorialTopView.create(page: page)
                tutorialTopView.frame.size = TutorialTopView.size()
                tutorialTopView.frame.origin.x = TutorialTopView.size().width * CGFloat(index)
                scrollView.addSubview(tutorialTopView)
        }
    }
    
    private func configureScrollView() {
        scrollView.contentSize = CGSize(
            width: TutorialTopView.size().width * CGFloat(TutorialTopView.Page.numberOfPages),
            height: TutorialTopView.size().height
        )
    }
}

extension TutorialViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DialogPresentationController(presentedViewController: presented, presenting: presenting, size: TutorialViewController.size())
    }
}
