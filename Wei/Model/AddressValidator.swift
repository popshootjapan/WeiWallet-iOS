//
//  AddressValidator.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/06/19.
//  Copyright © 2018 yz. All rights reserved.
//

import Foundation

struct AddressValidator {
    
    let address: String
    
    func validate() -> Bool {
        let isAddressNotEmpty = !address.isEmpty
        let isValidLength = address.count == 42
        let isStartWith0x = address.hasPrefix("0x")
        return isAddressNotEmpty && isValidLength && isStartWith0x
    }
}
