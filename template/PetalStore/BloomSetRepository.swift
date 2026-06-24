import Foundation
import SwiftData

@MainActor
final class BloomSetRepository {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchAll() throws -> [BloomSet] {
        let descriptor = FetchDescriptor<BloomSet>(sortBy: [SortDescriptor(\.sortOrder)])
        return try context.fetch(descriptor)
    }

    func fetchBuiltIn() throws -> [BloomSet] {
        try fetchAll().filter(\.isBuiltIn)
    }

    func fetchCustom() throws -> [BloomSet] {
        try fetchAll().filter { !$0.isBuiltIn }
    }

    func save(_ bloom: BloomSet) throws {
        context.insert(bloom)
        try context.save()
    }

    func delete(_ bloom: BloomSet) throws {
        context.delete(bloom)
        try context.save()
    }

    func update() throws {
        try context.save()
    }
}
