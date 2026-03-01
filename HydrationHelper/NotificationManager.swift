//
//  NotificationManager.swift
//  HydrationHelper
//
//  Manages system notifications for hydration reminders
//

import Foundation
import UserNotifications
import AppKit

/// Handles notification permissions and delivery
class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    /// Requests authorization to send notifications
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification authorization error: \(error.localizedDescription)")
            } else {
                print("Notification permission granted: \(granted)")
            }
        }
    }
    
    /// Sends a hydration reminder notification with sound
    func sendHydrationReminder() {
        let content = UNMutableNotificationContent()
        content.title = "💧 该喝水啦！"
        content.body = "保持水分充足，让身体更健康~"
        content.sound = .default
        content.categoryIdentifier = "HYDRATION_REMINDER"
        
        // Immediate trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            }
        }
        
        // Also play system beep as backup
        NSSound.beep()
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Show notification even when app is in foreground
        completionHandler([.banner, .sound])
    }
}