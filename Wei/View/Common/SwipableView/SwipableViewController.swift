//
//  SwipableViewController.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/12.
//  Copyright © 2018 popshoot All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SwipableViewController: UIViewController {
    
    var viewControllers: [UIViewController]!
    var titles: [String]!
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var pageControl: PageControl!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.scrollsToTop = false
        pageControl.titles.accept(titles)
        bindPageIndicator()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let contentSize = CGSize(width: scrollView.frame.width * CGFloat(viewControllers.count), height: 1.0)
        let updated = scrollView.contentSize.width != contentSize.width
        
        guard updated else {
            return
        }
        
        scrollView.contentSize = contentSize
        layoutViewControllers()
    }
    
    private func bindPageIndicator() {
        pageControl.selectedIndex.asDriver()
            .drive(onNext: { [weak self] index in
                guard let weakSelf = self else {
                    return
                }
                let offsetX = CGFloat(index) * weakSelf.scrollView.frame.width
                weakSelf.scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
            })
            .disposed(by: disposeBag)
        
        let interval = 1.0 / Double(viewControllers.count)
        
        scrollView.rx.scrollProgress.asDriver()
            .drive(onNext: { [weak self] progress in
                guard progress.truncatingRemainder(dividingBy: CGFloat(interval)) == 0 else {
                    return
                }
                self?.pageControl.selectedIndex.accept(Int(progress/CGFloat(interval)))
            })
            .disposed(by: disposeBag)
        
        scrollView.rx.scrollProgress.asDriver()
            .drive(pageControl.currentContentOffset)
            .disposed(by: disposeBag)
    }
    
    private func layoutViewControllers() {
        children.forEach(remove(_:))
        viewControllers.enumerated().forEach { index, viewController in
            viewController.view.frame = CGRect(origin: CGPoint(x: scrollView.frame.width * CGFloat(index), y: 0.0), size: scrollView.frame.size)
            scrollView.addSubview(viewController.view)
            addChild(viewController)
            viewController.didMove(toParent: self)
        }
    }
}
