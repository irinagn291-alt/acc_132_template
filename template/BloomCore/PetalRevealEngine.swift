import Foundation

@MainActor
final class PetalRevealEngine: ObservableObject {
    @Published private(set) var pluckedIndices: Set<Int> = []
    @Published private(set) var isRevealed = false
    @Published private(set) var revealedPetal: PetalChoice?

    let bloomSet: BloomSet
    private let petals: [PetalChoice]

    init(bloomSet: BloomSet) {
        self.bloomSet = bloomSet
        self.petals = bloomSet.sortedPetals
    }

    var totalPetals: Int { max(petals.count, 1) }
    var pluckedCount: Int { pluckedIndices.count }
    var remainingCount: Int { max(totalPetals - pluckedCount, 0) }
    var canPluck: Bool { !isRevealed && remainingCount > 0 }

    func pluckNext() -> PetalChoice? {
        guard canPluck else { return nil }

        let remaining = petals.indices.filter { !pluckedIndices.contains($0) }
        guard let index = remaining.randomElement() else { return nil }

        pluckedIndices.insert(index)
        let petal = petals[index]

        if pluckedIndices.count == petals.count {
            isRevealed = true
            revealedPetal = petal
        }

        return petal
    }

    func reset() {
        pluckedIndices.removeAll()
        isRevealed = false
        revealedPetal = nil
    }
}
