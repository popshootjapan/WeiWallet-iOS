//
//  UINotificationFeedbackGenerator+Extension.swift
//  Wei
//
//  Created by omatty198 on 2018/04/26.
//  Copyright © 2018年 popshoot All rights reserved.
//

import UIKit

extension UINotificationFeedbackGenerator {
    func successNotification() {
        self.prepare()
        self.notificationOccurred(.success)
    }
}
