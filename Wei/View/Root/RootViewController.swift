//
//  RootViewController.swift
//  Wei
//
//  Created by yuzushioh on 2018/03/11.
//  Copyright © 2018 popshoot. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class RootViewController: UIViewController {
    
    var viewModel: RootViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = RootViewModel.Input(
            viewWillAppear: rx.viewWillAppear.asDriver(),
            viewDidAppear: rx.viewDidAppear.asDriver()
        )
        
        let output = viewModel.build(input: input)
        
        output
            .presentCreateWalletViewController
            .drive(onNext: { [weak self] in
                self?.presentCreateWalletViewController()
            })
            .disposed(by: disposeBag)
        
        output
            .showTabBarController
            .drive(onNext: { [weak self] in
                self?.showTabBarController()
            })
            .disposed(by: disposeBag)
        
        output
            .presentAppStoreForForceUpdates
            .drive(onNext: { [weak self] in
                self?.openAppStore()
            })
            .disposed(by: disposeBag)
        
        output
            .presentMaintenanceViewController
            .drive(onNext: { [weak self] in
                self?.presentMaintenanceViewController()
            })
            .disposed(by: disposeBag)
        
        output
            .presentAgreeTermsViewController
            .drive(onNext: { [weak self] in
                self?.presentAgreeTermsViewController()
            })
            .disposed(by: disposeBag)
    }
    
    private func openAppStore() {
        showAlertController(
            title: "アップデートのお知らせ",
            message: "新しい機能が追加されました。\nアプリご利用いただくためにアップデートが必要になります。",
            actionTitle: "アップデートをする",
            handler: { [weak self] _ in
                UIApplication.wei.openAppStore()
                self?.openAppStore()
            })
    }
    
    func showTabBarController() {
        let viewController = TabBarController()
        embed(viewController, to: view)
    }
    
    private func presentCreateWalletViewController() {
        let viewController = CreateWalletViewController.make()
        let navigationController = NavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }
    
    private func presentMaintenanceViewController() {
        let viewController = MaintenanceViewController.make()
        present(viewController, animated: false)
    }
    
    private func presentAgreeTermsViewController() {
        let viewController = UpdateServiceTermsViewController.make()
        present(viewController, animated: true)
    }
}

extension RootViewController {
    #if !PRODUCTION
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionBegan(motion, with: event)
        
        func presentDebugListViewController() {
            let viewController = DebugListViewController.make()
            let navigationController = NavigationController(rootViewController: viewController)
            present(navigationController, animated: true)
        }
        
        if presentedViewController != nil {
            dismiss(animated: true)
        }
        
        presentDebugListViewController()
    }
    #endif
}

