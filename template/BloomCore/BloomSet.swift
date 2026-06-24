import Foundation
import SwiftData

enum BloomCategory: String, Codable, CaseIterable, Identifiable {
    case selfCare = "Self-Care"
    case mindfulness = "Mindfulness"
    case gratitude = "Gratitude"
    case rest = "Rest"
    case joy = "Joy"
    case nourishment = "Nourishment"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .selfCare: "heart.fill"
        case .mindfulness: "wind"
        case .gratitude: "sun.max.fill"
        case .rest: "moon.stars.fill"
        case .joy: "sparkles"
        case .nourishment: "cup.and.saucer.fill"
        }
    }
}

@Model
final class BloomSet {
    var id: UUID
    var name: String
    var bloomDescription: String
    var categoryRaw: String
    var isBuiltIn: Bool
    var createdAt: Date
    var sortOrder: Int
    @Relationship(deleteRule: .cascade, inverse: \PetalChoice.bloomSet)
    var petals: [PetalChoice]

    var category: BloomCategory {
        get { BloomCategory(rawValue: categoryRaw) ?? .selfCare }
        set { categoryRaw = newValue.rawValue }
    }

    init(
        id: UUID = UUID(),
        name: String,
        bloomDescription: String = "",
        category: BloomCategory,
        isBuiltIn: Bool = false,
        createdAt: Date = .now,
        sortOrder: Int = 0,
        petals: [PetalChoice] = []
    ) {
        self.id = id
        self.name = name
        self.bloomDescription = bloomDescription
        self.categoryRaw = category.rawValue
        self.isBuiltIn = isBuiltIn
        self.createdAt = createdAt
        self.sortOrder = sortOrder
        self.petals = petals
    }

    var sortedPetals: [PetalChoice] {
        petals.sorted { $0.sortOrder < $1.sortOrder }
    }
}
