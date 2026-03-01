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
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Hide dock icon
        NSApp.setActivationPolicy(.accessory)
        
        // Initialize status bar
        statusBarController = StatusBarController()
        
        // Request notification permission
        NotificationManager.shared.requestAuthorization()
    }
}