import Foundation
import SwiftData

enum PluckStatus: String, Codable, CaseIterable {
    case revealed
    case completed
    case skipped
}

@Model
final class PluckEntry {
    var id: UUID
    var bloomSetId: UUID
    var bloomSetName: String
    var revealedTitle: String
    var revealedDetails: String
    var pluckedAt: Date
    var statusRaw: String

    var status: PluckStatus {
        get { PluckStatus(rawValue: statusRaw) ?? .revealed }
        set { statusRaw = newValue.rawValue }
    }

    init(
        id: UUID = UUID(),
        bloomSetId: UUID,
        bloomSetName: String,
        revealedTitle: String,
        revealedDetails: String = "",
        pluckedAt: Date = .now,
        status: PluckStatus = .revealed
    ) {
        self.id = id
        self.bloomSetId = bloomSetId
        self.bloomSetName = bloomSetName
        self.revealedTitle = revealedTitle
        self.revealedDetails = revealedDetails
        self.pluckedAt = pluckedAt
        self.statusRaw = status.rawValue
    }
}
