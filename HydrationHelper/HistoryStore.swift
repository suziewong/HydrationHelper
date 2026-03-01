//
//  HistoryStore.swift
//  HydrationHelper
//
//  Manages hydration history records using UserDefaults
//

import Foundation

/// Represents a single hydration record
struct HydrationRecord: Codable, Identifiable {
    let id: UUID
    let timestamp: Date
    
    init(id: UUID = UUID(), timestamp: Date = Date()) {
        self.id = id
        self.timestamp = timestamp
    }
}

/// Manages persistence of hydration history
class HistoryStore: ObservableObject {
    static let shared = HistoryStore()
    
    @Published var records: [HydrationRecord] = []
    
    private let userDefaultsKey = "hydrationHistory"
    
    private init() {
        loadRecords()
    }
    
    /// Adds a new hydration record with current timestamp
    func addRecord() {
        let record = HydrationRecord()
        records.insert(record, at: 0) // Newest first
        saveRecords()
    }
    
    /// Returns records for today only
    func todayRecords() -> [HydrationRecord] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        return records.filter { $0.timestamp >= startOfDay }
    }
    
    /// Returns the total count of all records
    func totalCount() -> Int {
        return records.count
    }
    
    /// Clears all history records
    func clearAll() {
        records.removeAll()
        saveRecords()
    }
    
    // MARK: - Private Methods
    
    /// Loads records from UserDefaults
    private func loadRecords() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode([HydrationRecord].self, from: data) {
            records = decoded
        }
    }
    
    /// Saves records to UserDefaults
    private func saveRecords() {
        if let encoded = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
}