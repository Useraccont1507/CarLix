//
//  NotificationService.swift
//  CarLix
//
//  Created by Illia Verezei on 18.03.2025.
//

import Foundation
import UserNotifications
import UIKit

protocol NotificationServiceProtocol {
    func makeRequest(completion: @escaping (Bool) -> Void)
    func setNotification(carName: String, toDo: String, date: Date)
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
    
    func setNotification(carName: String, toDo: String, date: Date) {
        self.makeRequest { [weak self] isAllowed in
            guard let self = self else { return }
            
            if isAllowed {
                let content = UNMutableNotificationContent()
                content.title = "Нагадування про \(carName)"
                content.body = toDo
                content.sound = .default
                content.categoryIdentifier = "local"
                content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
                
                let trigerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute , .second], from: date)
                
                let triger = UNCalendarNotificationTrigger(dateMatching: trigerDate, repeats: false)
                
                let request = UNNotificationRequest(identifier: "nil", content: content, trigger: triger)
                    
                self.center.add(request)
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
