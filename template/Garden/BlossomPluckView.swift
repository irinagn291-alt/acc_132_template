import SwiftUI
import SwiftData

struct BlossomPluckView: View {
    @EnvironmentObject private var services: BloomServices
    @Environment(\.dismiss) private var dismiss
    @StateObject private var engine: PetalRevealEngine
    @State private var lastPluckedTitle: String?
    @State private var showResult = false

    init(bloomSet: BloomSet) {
        _engine = StateObject(wrappedValue: PetalRevealEngine(bloomSet: bloomSet))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text(engine.bloomSet.name)
                    .bloomSerifTitle(30)
                    .padding(.top, 8)

                FlowerHeroView(
                    totalPetals: engine.totalPetals,
                    pluckedCount: engine.pluckedCount,
                    reduceMotion: services.preferences.reduceAnimations
                )

                SoftGlassCard {
                    VStack(spacing: 12) {
                        Text("\(engine.remainingCount) petals left")
                            .font(.subheadline)
                            .foregroundStyle(BloomPalette.textMuted)
                        if let title = lastPluckedTitle, !engine.isRevealed {
                            Text("“\(title)”")
                                .font(.body.italic())
                                .foregroundStyle(BloomPalette.secondary)
                                .multilineTextAlignment(.center)
                        }
                        BloomPrimaryButton(
                            engine.isRevealed ? "Bloom Revealed" : "Pluck a Petal",
                            icon: "hand.point.up.left.fill",
                            isDisabled: !engine.canPluck
                        ) {
                            pluckPetal()
                        }
                    }
                }

                if engine.isRevealed, let petal = engine.revealedPetal {
                    revealCard(petal)
                }
            }
            .padding(16)
        }
        .bloomScreen()
        .navigationBarTitleDisplayMode(.inline)
    }

    private func pluckPetal() {
        guard let petal = engine.pluckNext() else { return }
        BloomHaptics.shared.impact(.light)
        lastPluckedTitle = petal.title
        if engine.isRevealed {
            BloomHaptics.shared.notify(.success)
            saveEntry(petal)
        }
    }

    private func revealCard(_ petal: PetalChoice) -> some View {
        SoftGlassCard {
            VStack(spacing: 14) {
                Text("Your bloom")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(BloomPalette.secondary)
                Text(petal.title).bloomSerifTitle(24).multilineTextAlignment(.center)
                Text(petal.details)
                    .font(.body)
                    .foregroundStyle(BloomPalette.textMuted)
                    .multilineTextAlignment(.center)
                HStack(spacing: 12) {
                    BloomPrimaryButton("Mark Done", icon: "checkmark") {
                        markDone()
                    }
                    Button("Later") { dismiss() }
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(BloomPalette.textMuted)
                }
            }
        }
    }

    private func saveEntry(_ petal: PetalChoice) {
        let entry = PluckEntry(
            bloomSetId: engine.bloomSet.id,
            bloomSetName: engine.bloomSet.name,
            revealedTitle: petal.title,
            revealedDetails: petal.details
        )
        try? services.journalRepository.add(entry)
    }

    private func markDone() {
        let entries = (try? services.journalRepository.fetchToday()) ?? []
        if let entry = entries.last(where: { $0.bloomSetId == engine.bloomSet.id }) {
            try? services.journalRepository.updateStatus(entry, status: .completed)
        }
        dismiss()
    }
}
