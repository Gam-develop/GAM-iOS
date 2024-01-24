//
//  PushNotificationHelper.swift
//  GAM
//
//  Created by Jungbin on 1/24/24.
//

import Foundation
import Firebase

class PushNotificationHelper {
    static let shared = PushNotificationHelper()

    private init() { }

    func setAuthorization() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound] // 필요한 알림 권한을 설정
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
    }
}
