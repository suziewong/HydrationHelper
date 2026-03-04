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
    func requestAuthorization(completion: ((Bool) -> Void)? = nil) {
        print("🔔 Requesting notification authorization...")
        
        // First, check current permission status
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("📊 Current notification status: \(settings.authorizationStatus.rawValue)")
            print("📊 Alert style: \(settings.alertStyle.rawValue)")
            
            DispatchQueue.main.async {
                if settings.authorizationStatus == .authorized {
                    print("✅ Already authorized!")
                    completion?(true)
                    return
                } else if settings.authorizationStatus == .denied {
                    print("❌ Notifications are denied!")
                    print("⚠️  Please enable notifications in: System Settings > Notifications & Focus > 喝水提醒")
                    completion?(false)
                    return
                } else if settings.authorizationStatus == .notDetermined {
                    print("ℹ️  Notification permission not determined yet")
                    // Request authorization
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                        DispatchQueue.main.async {
                            if let error = error {
                                print("❌ Notification authorization error: \(error.localizedDescription)")
                                print("   Error code: \(error.localizedDescription)")
                            } else {
                                print("✅ Notification permission granted: \(granted)")
                                if granted {
                                    print("🎉 Notifications are now enabled!")
                                } else {
                                    print("⚠️  Notifications were denied.")
                                    print("   Please enable in: System Settings > Notifications & Focus > 喝水提醒")
                                }
                            }
                            completion?(granted)
                        }
                    }
                } else {
                    print("⚠️  Notification permission status: \(settings.authorizationStatus.rawValue)")
                    completion?(false)
                }
            }
        }
    }
    
    /// Sends a hydration reminder notification with sound
    func sendHydrationReminder() {
        print("🔔 Sending hydration reminder notification...")
        
        // Check current notification settings
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("📊 Notification settings: \(settings.authorizationStatus.rawValue)")
            print("📊 Alert style: \(settings.alertStyle.rawValue)")
            
            DispatchQueue.main.async {
                var notificationSent = false
                
                // Method 1: Using UNUserNotificationCenter (preferred)
                if settings.authorizationStatus == .authorized {
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
                            print("❌ Failed to schedule notification: \(error.localizedDescription)")
                            // Try alternative methods if UNUserNotificationCenter fails
                            self.sendNotificationWithNSUserNotificationCenter()
                            self.sendNotificationWithAppleScript()
                        } else {
                            print("✅ Notification scheduled successfully!")
                            notificationSent = true
                        }
                    }
                } else {
                    print("❌ Not authorized to send notifications via UNUserNotificationCenter")
                    // Try alternative methods
                    self.sendNotificationWithNSUserNotificationCenter()
                    self.sendNotificationWithAppleScript()
                }
                
                // Also play system beep as backup
                NSSound.beep()
            }
        }
    }
    
    /// Sends notification using NSUserNotificationCenter (older API)
    private func sendNotificationWithNSUserNotificationCenter() {
        print("🔔 Sending notification via NSUserNotificationCenter...")
        
        if #available(macOS 10.14, *) {
            print("⚠️ NSUserNotificationCenter is deprecated in macOS 10.14+")
        }
        
        let notification = NSUserNotification()
        notification.title = "💧 该喝水啦！"
        notification.informativeText = "保持水分充足，让身体更健康~"
        notification.soundName = NSUserNotificationDefaultSoundName
        
        NSUserNotificationCenter.default.deliver(notification)
        print("✅ NSUserNotificationCenter notification sent!")
    }
    
    /// Sends notification using AppleScript
    private func sendNotificationWithAppleScript() {
        print("🔔 Sending notification via AppleScript...")
        
        let script = """
        display notification "保持水分充足，让身体更健康~" with title "💧 该喝水啦！" sound name "Ping"
        """
        
        let task = Process()
        task.launchPath = "/usr/bin/osascript"
        task.arguments = ["-e", script]
        
        do {
            try task.run()
            task.waitUntilExit()
            if task.terminationStatus == 0 {
                print("✅ AppleScript notification sent!")
            } else {
                print("❌ AppleScript notification failed with status: \(task.terminationStatus)")
            }
        } catch {
            print("❌ Error running AppleScript: \(error.localizedDescription)")
        }
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Show notification even when app is in foreground
        completionHandler([.banner, .sound])
    }
}