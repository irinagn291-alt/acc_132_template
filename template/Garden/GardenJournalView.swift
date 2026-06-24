import SwiftUI
import SwiftData

struct GardenJournalView: View {
    @EnvironmentObject private var services: BloomServices
    @State private var entries: [PluckEntry] = []

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    BloomSectionHeader(title: "Blossom Journal", subtitle: "Petals you have revealed")
                        .padding(.horizontal, 16)

                    if entries.isEmpty {
                        BloomEmptyState(
                            icon: "book.closed",
                            title: "No entries yet",
                            message: "Pluck a bloom to begin your journal."
                        )
                    } else {
                        ForEach(entries) { entry in
                            journalRow(entry)
                                .padding(.horizontal, 16)
                        }
                    }
                }
                .padding(.vertical, 12)
            }
            .bloomScreen()
            .onAppear { reload() }
        }
    }

    private func journalRow(_ entry: PluckEntry) -> some View {
        SoftGlassCard {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(entry.bloomSetName)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(BloomPalette.secondary)
                    Spacer()
                    statusBadge(entry.status)
                }
                Text(entry.revealedTitle).bloomSerifTitle(18)
                Text(entry.pluckedAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(BloomPalette.textMuted)
                if entry.status == .revealed {
                    HStack(spacing: 10) {
                        Button("Done") {
                            try? services.journalRepository.updateStatus(entry, status: .completed)
                            reload()
                        }
                        .font(.caption.weight(.semibold))
                        Button("Skip") {
                            try? services.journalRepository.updateStatus(entry, status: .skipped)
                            reload()
                        }
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(BloomPalette.textMuted)
                    }
                }
            }
        }
    }

    private func statusBadge(_ status: PluckStatus) -> some View {
        Text(status.rawValue.capitalized)
            .font(.caption2.weight(.bold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(BloomPalette.surface.opacity(0.7), in: Capsule())
    }

    private func reload() {
        entries = (try? services.journalRepository.fetchAll()) ?? []
    }
}
