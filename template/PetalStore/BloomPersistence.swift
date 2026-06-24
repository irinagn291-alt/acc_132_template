import SwiftData
import SwiftUI

enum BloomPersistence {
    static let schema = Schema([BloomSet.self, PetalChoice.self, PluckEntry.self])

    static func makeContainer() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: false)
        return try ModelContainer(for: schema, configurations: [config])
    }
}
