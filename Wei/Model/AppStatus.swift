//
//  AppStatus.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/12.
//  Copyright © 2018 popshoot All rights reserved.
//

struct AppStatus: Decodable {
    let isUnderMaintenance: Bool
    let forceUpdates: Bool
    let needsAgreeTerms: Bool
    
    enum CodingKeys: String, CodingKey {
        case isUnderMaintenance = "maintenance_ongoing"
        case forceUpdates = "need_update"
        case needsAgreeTerms = "need_terms_agreement"
    }
}
