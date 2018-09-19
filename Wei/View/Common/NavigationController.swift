//
//  NavigationController.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/01.
//  Copyright © 2018 popshoot All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class NavigationController: UINavigationController {
    
    override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate var isTransiting = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBaseAppearence()
        
        delegate = self
        interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isTransiting = false
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        guard !isTransiting else { return }
        addBackButton(viewController)
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        guard !isTransiting else { return nil }
        return super.popViewController(animated: animated)
    }
    
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        guard !isTransiting else { return nil }
        return super.popToViewController(viewController, animated: animated)
    }
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        guard !isTransiting else { return nil }
        return super.popToRootViewController(animated: animated)
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        guard !isTransiting else { return }
        viewControllers.forEach(addBackButton)
        super.setViewControllers(viewControllers, animated: animated)
    }
    
    private func addBackButton(_ viewController: UIViewController) {
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = backButtonItem
    }
    
    private func setBaseAppearence() {
        // TODO: change color
        navigationBar.tintColor = UIColor.wei.black
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationBar.isTranslucent = false
    }
}

extension NavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        topViewControllerWillChange(to: viewController, animated: animated)
        
        transitionCoordinator?.notifyWhenInteractionChanges { [weak self] context in
            guard let weakSelf = self, let from = context.viewController(forKey: .from), context.isCancelled else {
                return
            }
            
            from.rx.viewWillAppear.asObservable()
                .take(1)
                .subscribe(onNext: { [weak self, weak from] _ in
                    guard let strongFrom = from else { return }
                    self?.topViewControllerWillChange(to: strongFrom, animated: animated)
                })
                .disposed(by: weakSelf.disposeBag)
            
            from.rx.viewDidAppear.asObservable()
                .take(1)
                .subscribe(onNext: { [weak self] _ in
                    self?.isTransiting = false
                })
                .disposed(by: weakSelf.disposeBag)
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        isTransiting = false
    }
    
    private func topViewControllerWillChange(to viewController: UIViewController, animated: Bool) {
        isTransiting = animated
        let isNavigationBarHidden = (viewController as? ControllableNavigationBar)?.setNavigationBarHiddenOnDisplay() ?? false
        if self.isNavigationBarHidden != isNavigationBarHidden {
            setNavigationBarHidden(isNavigationBarHidden, animated: animated)
        }
    }
}

extension NavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return 1 < viewControllers.count && !isTransiting
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
