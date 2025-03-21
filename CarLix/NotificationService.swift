//
//  NotificationService.swift
//  CarLix
//
//  Created by Illia Verezei on 18.03.2025.
//

import Foundation
import UserNotifications

protocol NotificationServiceProtocol {
    func makeRequest(completion: @escaping (Bool) -> Void)
}

final class NotificationService: NotificationServiceProtocol {
    private let center = UNUserNotificationCenter.current()
    
    init(delegate: NotificationDelegate) {
        center.delegate = delegate
    }
    
    func makeRequest(completion: @escaping (Bool) -> Void) {
        center.getNotificationSettings { [weak self] settings in
            guard let self = self else { return }
            
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                completion(true)
            case .denied:
                self.requestAuthorization(completion: completion)
            case .notDetermined:
                self.requestAuthorization(completion: completion)
            case .ephemeral:
                self.requestAuthorization(completion: completion)
            @unknown default:
                print("Unknown notification authorization status")
            }
        }
    }
    
    private func requestAuthorization(completion: @escaping (Bool) -> Void) {
        center.requestAuthorization(options: [.alert, .badge, .sound]) { isAllowed, _ in
            completion(isAllowed)
        }
    }
}

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .list, .sound])
    }
}
