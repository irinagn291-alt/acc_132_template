import Foundation
import SwiftData

@MainActor
final class PluckJournalRepository {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchAll() throws -> [PluckEntry] {
        let descriptor = FetchDescriptor<PluckEntry>(
            sortBy: [SortDescriptor(\.pluckedAt, order: .reverse)]
        )
        return try context.fetch(descriptor)
    }

    func fetchToday() throws -> [PluckEntry] {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: .now)
        return try fetchAll().filter { calendar.isDate($0.pluckedAt, inSameDayAs: start) }
    }

    func add(_ entry: PluckEntry) throws {
        context.insert(entry)
        try context.save()
    }

    func updateStatus(_ entry: PluckEntry, status: PluckStatus) throws {
        entry.status = status
        try context.save()
    }

    func deleteAll() throws {
        try fetchAll().forEach { context.delete($0) }
        try context.save()
    }
}
