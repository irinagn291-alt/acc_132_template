import Foundation
import SwiftData

enum BuiltInBloomSeeder {
    static func seedIfNeeded(context: ModelContext) {
        let key = AppConstants.hasSeededBuiltInBloomsKey
        guard !UserDefaults.standard.bool(forKey: key) else { return }

        let packs: [(String, String, BloomCategory, [String])] = [
            ("Morning Glow", "Gentle rituals to welcome your day", .selfCare, [
                "Sip warm water with lemon",
                "Stretch by the window for five minutes",
                "Write one intention for today",
                "Play a soft song while getting ready",
                "Take three slow breaths before checking your phone"
            ]),
            ("Soft Pause", "Tiny breaks for your nervous system", .mindfulness, [
                "Close your eyes and count ten breaths",
                "Name five things you can see",
                "Roll your shoulders slowly three times",
                "Step outside for fresh air",
                "Place a hand on your heart and smile"
            ]),
            ("Gratitude Petals", "Small moments of appreciation", .gratitude, [
                "Text someone you appreciate",
                "Write down one beautiful detail from today",
                "Thank your body for carrying you",
                "Notice a color that makes you happy",
                "Recall a kind gesture you received"
            ]),
            ("Evening Unwind", "Calm closures before rest", .rest, [
                "Dim the lights one hour before bed",
                "Journal one line about today",
                "Brew caffeine-free tea",
                "Read a few pages of something gentle",
                "List three things that went well"
            ]),
            ("Joy Sprinkles", "Playful sparks of delight", .joy, [
                "Dance to one favorite song",
                "Wear something that feels lovely",
                "Buy or pick a small flower",
                "Send a voice note to a friend",
                "Try a new cozy snack"
            ]),
            ("Nourish Bloom", "Kind choices for your body", .nourishment, [
                "Add greens to one meal",
                "Drink an extra glass of water",
                "Eat without scrolling",
                "Prepare a colorful snack plate",
                "Cook something that smells wonderful"
            ])
        ]

        for (index, pack) in packs.enumerated() {
            let bloom = BloomSet(
                name: pack.0,
                bloomDescription: pack.1,
                category: pack.2,
                isBuiltIn: true,
                sortOrder: index
            )
            bloom.petals = pack.3.enumerated().map { offset, title in
                PetalChoice(title: title, details: "A gentle act of care.", sortOrder: offset)
            }
            context.insert(bloom)
        }

        try? context.save()
        UserDefaults.standard.set(true, forKey: key)
    }

    static func resetBuiltIn(context: ModelContext) throws {
        let descriptor = FetchDescriptor<BloomSet>()
        let blooms = try context.fetch(descriptor).filter(\.isBuiltIn)
        blooms.forEach { context.delete($0) }
        try context.save()
        UserDefaults.standard.set(false, forKey: AppConstants.hasSeededBuiltInBloomsKey)
        seedIfNeeded(context: context)
    }
}
