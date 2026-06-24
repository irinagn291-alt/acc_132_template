import Foundation
import SwiftData

@Model
final class PetalChoice {
    var id: UUID
    var title: String
    var details: String
    var sortOrder: Int
    var bloomSet: BloomSet?

    init(id: UUID = UUID(), title: String, details: String = "", sortOrder: Int = 0) {
        self.id = id
        self.title = title
        self.details = details
        self.sortOrder = sortOrder
    }
}
