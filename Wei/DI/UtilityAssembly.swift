//
//  UtilityAssembly.swift
//  Wei
//
//  Created by yuzushioh on 2018/03/15.
//  Copyright © 2018 popshoot. All rights reserved.
//

import Swinject

final class UtilityAssembly: Assembly {
    func assemble(container: Container) {
        
        // MARK: - Utility
        
        // KeychainStore
        
        container.register(KeychainStore.self) { resolver in
            return KeychainStore(environment: Environment.current)
        }
        
        // ApplicationStore
        
        container
            .register(ApplicationStoreProtocol.self) { resolver in
                return ApplicationStore(dependency: (
                    resolver.resolve(KeychainStore.self)!
                ))
            }
            .inObjectScope(.container)
        
        // RateStore
        
        container
            .register(RateStoreProtocol.self) { resolver in
                return RateStore(dependency: (
                    resolver.resolve(CacheProtocol.self)!,
                    resolver.resolve(RateRepositoryProtocol.self)!,
                    resolver.resolve(UpdaterProtocol.self)!
                ))
            }
            .inObjectScope(.container)
        
        // BalanceStore
        
        container
            .register(BalanceStoreProtocol.self) { resolver in
                return BalanceStore(dependency: (
                    resolver.resolve(GethRepositoryProtocol.self)!,
                    resolver.resolve(WalletManagerProtocol.self)!,
                    resolver.resolve(UpdaterProtocol.self)!,
                    resolver.resolve(RateStoreProtocol.self)!
                ))
            }
            .inObjectScope(.container)
        
        // WalletManager
        
        container
            .register(WalletManagerProtocol.self) { resolver in
                return WalletManager(dependency: (
                    resolver.resolve(ApplicationStoreProtocol.self)!
                ))
            }
            .inObjectScope(.container)
        
        // RealmManager
        
        container
            .register(RealmManagerProtocol.self) { resolver in
                return RealmManager()
            }
            .inObjectScope(.container)
        
        // APIClient
        
        container
            .register(APIClientProtocol.self) { resolver in
                return APIClient()
            }
            .inObjectScope(.container)
        
        // Cache
        
        container
            .register(CacheProtocol.self) { resolver in
                return Cache()
            }
            .inObjectScope(.container)
        
        container.register(DeviceCheckerProtocol.self) { resolver in
            return DeviceChecker()
        }
        
        // MnemonicManager
        
        container.register(MnemonicManagerProtocol.self) { resolver in
            return MnemonicManager()
        }
        
        // QRCoderProtocol
        
        container.register(QRCoderProtocol.self) { (resolver, delegate: QRCoderDelegate?) in
            return QRCoder(delegate: delegate)
        }
        
        
        // UpdaterProtocol
        
        container
            .register(UpdaterProtocol.self) { resolver in
                return Updater()
            }
            .inObjectScope(.container)
        
        // MARK: - Repository
        
        // EthereumRepository
        
        container.register(GethRepositoryProtocol.self) { resolver in
            return GethRepository()
        }
        
        // RateRepository
        
        container.register(RateRepositoryProtocol.self) { resolver in
            return RateRepository(dependency: (
                resolver.resolve(APIClientProtocol.self)!
            ))
        }
        
        // StatusRepository
        
        container.register(AppStatusRepositoryProtocol.self) { resolver in
            return AppStatusRepository(dependency: (
                resolver.resolve(APIClientProtocol.self)!
            ))
        }
        
        // RegistrationRepository
        
        container.register(RegistrationRepositoryProtocol.self) { resolver in
            return RegistrationRepository(dependency: (
                resolver.resolve(APIClientProtocol.self)!
            ))
        }
        
        // LocalTransactionRepository
        
        container.register(LocalTransactionRepositoryProtocol.self) { resolver in
            return LocalTransactionRepository(dependency: (
                resolver.resolve(RealmManagerProtocol.self)!
            ))
        }
    }
}

extension Cache {
    static let shared = Container.shared.resolve(CacheProtocol.self)!
}
