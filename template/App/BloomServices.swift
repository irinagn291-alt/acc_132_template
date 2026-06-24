import SwiftUI
import SwiftData
import Combine

@MainActor
final class BloomServices: ObservableObject {
    let preferences: BloomPreferences
    let bloomRepository: BloomSetRepository
    let journalRepository: PluckJournalRepository

    private var cancellables = Set<AnyCancellable>()

    init(context: ModelContext) {
        preferences = BloomPreferences()
        bloomRepository = BloomSetRepository(context: context)
        journalRepository = PluckJournalRepository(context: context)
        preferences.objectWillChange
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }
}
