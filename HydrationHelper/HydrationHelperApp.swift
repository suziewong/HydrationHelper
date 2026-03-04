//
//  HydrationHelperApp.swift
//  HydrationHelper
//
//  Created by AI Assistant on 2026/03/01.
//

import SwiftUI
import AppKit

@main
struct HydrationHelperApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarController: StatusBarController?
    var permissionWindow: NSWindow?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        print("🚀 App launching...")
        
        // Check if we need to request permission
        let permissionRequested = UserDefaults.standard.bool(forKey: "notificationPermissionRequested")
        
        if !permissionRequested {
            print("📢 First launch - requesting notification permission...")
            requestNotificationPermission()
        } else {
            print("✓ Permission already requested, initializing directly...")
            initializeApp()
        }
    }
    
    func requestNotificationPermission() {
        // Create a simple alert-based permission window
        let alert = NSAlert()
        alert.messageText = "喝水提醒"
        alert.informativeText = "喝水提醒需要发送通知来提醒您喝水。请在弹出的系统提示中点击'允许'。"
        alert.addButton(withTitle: "我已允许")
        alert.addButton(withTitle: "稍后")
        
        // Bring app to front to ensure system dialog is visible
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
        
        // Request authorization BEFORE showing alert
        NotificationManager.shared.requestAuthorization { granted in
            DispatchQueue.main.async {
                // Show alert after permission request
                let response = alert.runModal()
                
                if response == .alertFirstButtonReturn {
                    // User clicked "我已允许"
                    print("✓ User confirmed they allowed notifications")
                    UserDefaults.standard.set(true, forKey: "notificationPermissionRequested")
                    self.initializeApp()
                } else {
                    // User clicked "稍后" or closed the dialog
                    print("⚠️ User postponed permission request")
                    UserDefaults.standard.set(true, forKey: "notificationPermissionRequested")
                    self.initializeApp()
                }
            }
        }
    }
    
    func initializeApp() {
        // Initialize status bar
        statusBarController = StatusBarController()
        
        // Delay hiding dock icon
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            NSApp.setActivationPolicy(.accessory)
            print("✓ Dock icon hidden")
        }
    }
}