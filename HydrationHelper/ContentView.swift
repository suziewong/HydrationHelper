//
//  ContentView.swift
//  HydrationHelper
//
//  Main user interface for the hydration timer
//

import SwiftUI
import AppKit

struct ContentView: View {
    @ObservedObject var timerManager: TimerManager
    @ObservedObject var historyStore = HistoryStore.shared
    @State private var intervalText: String = "60"
    @State private var showValidationError: Bool = false
    
    private let quickIntervals = [1, 5, 15, 30, 60]
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            headerView
            
            Divider()
            
            // Timer Display
            timerDisplayView
            
            // Control Buttons
            controlButtonsView
            
            Divider()
            
            // Interval Settings
            intervalSettingsView
            
            Divider()
            
            // History Stats
            historyStatsView
        }
        .padding()
        .frame(width: 300)
        .onAppear {
            intervalText = String(timerManager.intervalMinutes)
        }
    }
    
    // MARK: - Subviews
    
    private var headerView: some View {
        HStack {
            Text("💧 HydrationHelper")
                .font(.headline)
            Spacer()
            Button(action: quitApp) {
                Image(systemName: "xmark.circle")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            .buttonStyle(.plain)
        }
    }
    
    private var timerDisplayView: some View {
        VStack(spacing: 8) {
            Text(formattedTime(timerManager.timeRemaining))
                .font(.system(size: 48, weight: .bold, design: .monospaced))
                .foregroundColor(timerColor)
            
            Text(timerManager.isRunning ? "计时中..." : "已暂停")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 10)
    }
    
    private var controlButtonsView: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Button(action: {
                    if timerManager.isRunning {
                        timerManager.pauseTimer()
                    } else {
                        timerManager.startTimer()
                    }
                }) {
                    Text(timerManager.isRunning ? "暂停" : "开始")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                
                Button(action: {
                    timerManager.resetTimer()
                }) {
                    Text("重置")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            
            Button(action: testNotification) {
                Label("测试通知", systemImage: "bell.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .tint(.blue)
        }
    }
    
    private var intervalSettingsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("提醒间隔")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                TextField("分钟", text: $intervalText)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 80)
                    .onSubmit {
                        validateAndSetInterval()
                    }
                
                Text("分钟")
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button("应用") {
                    validateAndSetInterval()
                }
                .buttonStyle(.bordered)
            }
            
            if showValidationError {
                Text("请输入1-480之间的数值")
                    .font(.caption)
                    .foregroundColor(.red)
            }
            
            // Quick interval buttons
            HStack(spacing: 8) {
                ForEach(quickIntervals, id: \.self) { interval in
                    QuickIntervalButton(
                        interval: interval,
                        isSelected: timerManager.intervalMinutes == interval,
                        action: {
                            setInterval(interval)
                        }
                    )
                }
            }
            .padding(.top, 4)
        }
    }
    
    private var historyStatsView: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text("今日喝水")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(historyStore.todayRecords().count) 次")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("总计")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(historyStore.totalCount()) 次")
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
            
            if timerManager.timeRemaining == 0 && !timerManager.isRunning {
                Button(action: {
                    timerManager.completeHydration()
                }) {
                    Label("已完成喝水", systemImage: "checkmark.circle.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    /// Validates interval input and applies if valid
    private func validateAndSetInterval() {
        if let minutes = Int(intervalText) {
            setInterval(minutes)
        } else {
            showValidationError = true
        }
    }
    
    /// Sets the interval with validation
    private func setInterval(_ minutes: Int) {
        if minutes >= 1 && minutes <= 480 {
            timerManager.setInterval(minutes: minutes)
            intervalText = String(minutes)
            showValidationError = false
        } else {
            showValidationError = true
        }
    }
    
    /// Formats time interval as MM:SS
    private func formattedTime(_ interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    /// Returns color based on remaining time percentage
    private var timerColor: Color {
        let totalTime = Double(timerManager.intervalMinutes * 60)
        let percentage = timerManager.timeRemaining / totalTime
        
        if percentage > 0.5 {
            return .primary
        } else if percentage > 0.25 {
            return .orange
        } else {
            return .red
        }
    }
    
    /// Quits the application
    private func quitApp() {
        NSApplication.shared.terminate(nil)
    }
    
    /// Sends a test notification immediately
    private func testNotification() {
        NotificationManager.shared.sendHydrationReminder()
    }
}

/// Helper struct for quick interval buttons
struct QuickIntervalButton: View {
    let interval: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("\(interval)")
                .font(.caption)
                .fontWeight(isSelected ? .bold : .regular)
                .frame(width: 36, height: 28)
        }
        .buttonStyle(.bordered)
        .tint(isSelected ? .blue : .secondary)
    }
}


