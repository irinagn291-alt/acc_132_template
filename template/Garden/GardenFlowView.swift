import SwiftUI
import SwiftData

@MainActor
final class GardenFlowViewModel: ObservableObject {
    @Published var blooms: [BloomSet] = []
    @Published var entries: [PluckEntry] = []
    @Published var dailyBloom: BloomSet?
    @Published var todayEntry: PluckEntry?

    var streak: Int { BloomStreakCalculator.currentStreak(from: entries) }
    var weekActivity: [Bool] { BloomStreakCalculator.weekActivity(from: entries) }

    func reload(services: BloomServices) {
        blooms = (try? services.bloomRepository.fetchAll()) ?? []
        entries = (try? services.journalRepository.fetchAll()) ?? []
        let today = (try? services.journalRepository.fetchToday()) ?? []
        todayEntry = today.first

        if let preferredId = services.preferences.defaultDailyBloomId,
           let preferred = blooms.first(where: { $0.id == preferredId }) {
            dailyBloom = preferred
        } else {
            dailyBloom = blooms.first
        }
    }
}

struct GardenFlowView: View {
    @EnvironmentObject private var services: BloomServices
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = GardenFlowViewModel()
    @State private var selectedBloom: BloomSet?
    @State private var scrollOffset: CGFloat = 0

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    header
                    FlowerHeroView(
                        totalPetals: viewModel.dailyBloom?.sortedPetals.count ?? 6,
                        pluckedCount: viewModel.todayEntry == nil ? 0 : (viewModel.dailyBloom?.sortedPetals.count ?? 6),
                        reduceMotion: services.preferences.reduceAnimations
                    )
                    PetalStreakRow(streak: viewModel.streak, weekActivity: viewModel.weekActivity)
                    todayBloomCard
                    packsSection
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            .bloomScreen()
            .navigationDestination(isPresented: Binding(
                get: { selectedBloom != nil },
                set: { if !$0 { selectedBloom = nil } }
            )) {
                if let bloom = selectedBloom {
                    BlossomPluckView(bloomSet: bloom)
                }
            }
            .onAppear {
                viewModel.reload(services: services)
                BloomHaptics.shared.setEnabled(services.preferences.hapticsEnabled)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Good \(greeting), blossom")
                .font(.subheadline)
                .foregroundStyle(BloomPalette.textMuted)
            Text(AppConstants.appName)
                .bloomSerifTitle(34)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 8)
    }

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: .now)
        switch hour {
        case 5..<12: return "morning"
        case 12..<17: return "afternoon"
        default: return "evening"
        }
    }

    private var todayBloomCard: some View {
        SoftGlassCard {
            VStack(alignment: .leading, spacing: 12) {
                BloomSectionHeader(
                    title: "Today's Bloom",
                    subtitle: viewModel.dailyBloom?.name ?? "Choose a bloom pack"
                )
                if let bloom = viewModel.dailyBloom {
                    HStack {
                        Image(systemName: bloom.category.icon)
                            .foregroundStyle(BloomPalette.secondary)
                        Text(bloom.bloomDescription)
                            .font(.subheadline)
                            .foregroundStyle(BloomPalette.textMuted)
                    }
                    if let entry = viewModel.todayEntry {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Revealed")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(BloomPalette.secondary)
                            Text(entry.revealedTitle)
                                .bloomSerifTitle(20)
                        }
                    } else {
                        BloomPrimaryButton("Pluck Today's Petals", icon: "hand.point.up.left.fill") {
                            selectedBloom = bloom
                        }
                    }
                } else {
                    BloomEmptyState(
                        icon: "leaf",
                        title: "No blooms yet",
                        message: "Browse blossom packs to begin."
                    )
                }
            }
        }
    }

    private var packsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            BloomSectionHeader(title: "Blossom Packs", subtitle: "Swipe up through your garden library")
            ForEach(Array(viewModel.blooms.enumerated()), id: \.element.id) { index, bloom in
                Button { selectedBloom = bloom } label: {
                    packCard(bloom, index: index)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func packCard(_ bloom: BloomSet, index: Int) -> some View {
        SoftGlassCard {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(BloomPalette.heroGradient)
                        .frame(width: 52, height: 52)
                    Image(systemName: bloom.category.icon)
                        .foregroundStyle(.white)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(bloom.name).bloomSerifTitle(18)
                    Text("\(bloom.sortedPetals.count) petals · \(bloom.category.rawValue)")
                        .font(.caption)
                        .foregroundStyle(BloomPalette.textMuted)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(BloomPalette.textMuted)
            }
        }
        .offset(y: parallaxOffset(for: index))
    }

    private func parallaxOffset(for index: Int) -> CGFloat {
        guard !services.preferences.reduceAnimations else { return 0 }
        return CGFloat(index % 3) * 4
    }
}
