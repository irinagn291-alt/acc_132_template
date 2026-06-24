import Foundation

enum BloomStreakCalculator {
    static func currentStreak(from entries: [PluckEntry]) -> Int {
        guard !entries.isEmpty else { return 0 }

        let calendar = Calendar.current
        let activeDays = Set(entries.map { calendar.startOfDay(for: $0.pluckedAt) })
        var streak = 0
        var day = calendar.startOfDay(for: .now)

        while activeDays.contains(day) {
            streak += 1
            guard let previous = calendar.date(byAdding: .day, value: -1, to: day) else { break }
            day = previous
        }
        return streak
    }

    static func weekActivity(from entries: [PluckEntry]) -> [Bool] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let activeDays = Set(entries.map { calendar.startOfDay(for: $0.pluckedAt) })

        return (0..<7).map { offset in
            guard let date = calendar.date(byAdding: .day, value: -(6 - offset), to: today) else { return false }
            return activeDays.contains(date)
        }
    }
}
