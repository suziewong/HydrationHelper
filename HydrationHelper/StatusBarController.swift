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
    
    override init() {
        // Create status bar item with variable length
        statusItem = NSStatusBar.shared.statusItem(withLength: NSStatusItem.variableLength)
        
        // Initialize popover
        popover = NSPopover()
        popover.behavior = .transient
        
        // Create content view with timer manager
        let timerManager = TimerManager.shared
        contentView = ContentView(timerManager: timerManager)
        popover.contentViewController = NSHostingController(rootView: contentView)
        
        super.init()
        
        setupStatusBar()
    }
    
    /// Configures the status bar icon and action
    private func setupStatusBar() {
        if let button = statusItem.button {
            // Use water drop emoji as icon
            button.title = "💧"
            button.font = NSFont.systemFont(ofSize: 16)
            button.action = #selector(togglePopover)
            button.target = self
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
        }
    }
    
    /// Closes the popover
    private func closePopover() {
        popover.performClose(nil)
    }
}