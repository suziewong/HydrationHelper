//
//  TimerManager.swift
//  HydrationHelper
//
//  Manages hydration reminder timer logic
//

import Foundation
import Combine

/// Manages the countdown timer for hydration reminders
class TimerManager: ObservableObject {
    static let shared = TimerManager()
    
    // MARK: - Published Properties
    @Published var timeRemaining: TimeInterval = 0
    @Published var isRunning: Bool = false
    @Published var intervalMinutes: Int = 60
    
    // MARK: - Private Properties
    private var timer: Timer?
    private let userDefaultsKey = "hydrationInterval"
    
    // MARK: - Initialization
    init() {
        loadIntervalFromStorage()
        timeRemaining = TimeInterval(intervalMinutes * 60)
    }
    
    // MARK: - Public Methods
    
    /// Starts the countdown timer
    func startTimer() {
        guard !isRunning else { return }
        
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }
    
    /// Pauses the countdown timer
    func pauseTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    /// Resets the timer to the full interval
    func resetTimer() {
        pauseTimer()
        timeRemaining = TimeInterval(intervalMinutes * 60)
    }
    
    /// Updates the timer interval and saves to UserDefaults
    /// - Parameter minutes: New interval in minutes (45, 60, or 90)
    func setInterval(minutes: Int) {
        intervalMinutes = minutes
        saveIntervalToStorage()
        resetTimer()
    }
    
    /// Marks current hydration as complete and restarts timer
    func completeHydration() {
        HistoryStore.shared.addRecord()
        resetTimer()
        startTimer()
    }
    
    // MARK: - Private Methods
    
    /// Decrements timer by one second and triggers notification when reaching zero
    private func tick() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            timerDidFinish()
        }
    }
    
    /// Handles timer completion by showing notification and playing sound
    private func timerDidFinish() {
        pauseTimer()
        NotificationManager.shared.sendHydrationReminder()
    }
    
    /// Loads saved interval from UserDefaults, defaults to 60 minutes
    private func loadIntervalFromStorage() {
        if let savedInterval = UserDefaults.standard.object(forKey: userDefaultsKey) as? Int {
            intervalMinutes = savedInterval
        } else {
            intervalMinutes = 60 // Default: 60 minutes
        }
    }
    
    /// Saves current interval to UserDefaults
    private func saveIntervalToStorage() {
        UserDefaults.standard.set(intervalMinutes, forKey: userDefaultsKey)
    }
}