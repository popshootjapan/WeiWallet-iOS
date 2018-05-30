//
//  Container+Extension.swift
//  Wei
//
//  Created by yuzushioh on 2018/03/11.
//  Copyright © 2018 popshoot. All rights reserved.
//

import Swinject

extension Container {
    static let shared = assembler.resolver
    
    private static let assembler = Assembler([
        ViewControllerAssembly(),
        ViewModelAssembly(),
        UtilityAssembly(),
    ])
}
