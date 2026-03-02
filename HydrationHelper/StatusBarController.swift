//
//  StatusBarController.swift
//  HydrationHelper
//
//  Manages the status bar icon and popover interface
//

import AppKit
import SwiftUI

class StatusBarController: NSObject {
    private var statusItem: NSStatusItem
    private var popover: NSPopover
    private var contentView: ContentView
    private var eventMonitor: Any?
    
    override init() {
        // Create status bar item with variable length
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        print("HydrationHelper: StatusBarController.init - statusItem created: \(statusItem)")
        
        // Initialize popover
        popover = NSPopover()
        popover.behavior = .transient
        popover.contentSize = NSSize(width: 300, height: 400)
        
        // Create content view with timer manager
        let timerManager = TimerManager.shared
        contentView = ContentView(timerManager: timerManager)
        popover.contentViewController = NSHostingController(rootView: contentView)
        
        super.init()
        
        setupStatusBar()
        setupEventMonitor()
    }
    
    deinit {
        if let eventMonitor = eventMonitor {
            NSEvent.removeMonitor(eventMonitor)
        }
    }
    
    /// Configures the status bar icon and action
    private func setupStatusBar() {
        if let button = statusItem.button {
            print("HydrationHelper: setupStatusBar - status bar button exists")
            // Use water drop emoji as icon
            button.title = "💧"
            button.font = NSFont.systemFont(ofSize: 16)
            button.action = #selector(togglePopover)
            button.target = self
        }
    }
    
    private func setupEventMonitor() {
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] _ in
            if self?.popover.isShown == true {
                self?.closePopover()
            }
        }
    }
    
    /// Toggles the popover visibility when status bar icon is clicked
    @objc private func togglePopover() {
        if popover.isShown {
            closePopover()
        } else {
            showPopover()
        }
    }
    
    /// Displays the popover relative to the status bar button
    private func showPopover() {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            NSApp.activate(ignoringOtherApps: true)
        }
    }
    
    /// Closes the popover
    private func closePopover() {
        popover.performClose(nil)
    }
}
