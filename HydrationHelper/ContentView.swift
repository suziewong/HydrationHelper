//
//  ContentView.swift
//  HydrationHelper
//
//  Main user interface for the hydration timer
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var timerManager: TimerManager
    @ObservedObject var historyStore = HistoryStore.shared
    @State private var selectedInterval: Int = 60
    
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
            selectedInterval = timerManager.intervalMinutes
        }
    }
    
    // MARK: - Subviews
    
    private var headerView: some View {
        HStack {
            Text("💧 HydrationHelper")
                .font(.headline)
            Spacer()
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
    }
    
    private var intervalSettingsView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("提醒间隔")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Picker("间隔", selection: $selectedInterval) {
                Text("45分钟").tag(45)
                Text("60分钟").tag(60)
                Text("90分钟").tag(90)
            }
            .pickerStyle(.segmented)
            .onChange(of: selectedInterval) { newValue in
                timerManager.setInterval(minutes: newValue)
            }
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
}

#Preview {
    ContentView(timerManager: TimerManager.shared)
}