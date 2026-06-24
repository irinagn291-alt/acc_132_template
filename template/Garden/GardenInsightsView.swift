import SwiftUI

struct GardenInsightsView: View {
    @EnvironmentObject private var services: BloomServices
    @State private var entries: [PluckEntry] = []

    private var completed: Int { entries.filter { $0.status == .completed }.count }
    private var streak: Int { BloomStreakCalculator.currentStreak(from: entries) }
    private var topBloom: String? {
        Dictionary(grouping: entries, by: \.bloomSetName)
            .max(by: { $0.value.count < $1.value.count })?
            .key
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 14) {
                    BloomSectionHeader(title: "Garden Insights", subtitle: "Your blooming patterns")
                        .padding(.horizontal, 16)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        metricCard("Total Plucks", "\(entries.count)", "hand.point.up.left.fill")
                        metricCard("Completed", "\(completed)", "checkmark.seal.fill")
                        metricCard("Streak", "\(streak)", "flame.fill")
                        metricCard("Favorite", topBloom ?? "—", "heart.fill")
                    }
                    .padding(.horizontal, 16)

                    categoryBreakdown
                        .padding(.horizontal, 16)
                }
                .padding(.vertical, 12)
            }
            .bloomScreen()
            .onAppear { reload() }
        }
    }

    private func metricCard(_ title: String, _ value: String, _ icon: String) -> some View {
        SoftGlassCard {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: icon).foregroundStyle(BloomPalette.primary)
                Text(value).bloomSerifTitle(22).lineLimit(1).minimumScaleFactor(0.7)
                Text(title).font(.caption).foregroundStyle(BloomPalette.textMuted)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var categoryBreakdown: some View {
        SoftGlassCard {
            VStack(alignment: .leading, spacing: 10) {
                Text("This month").bloomSerifTitle(20)
                let monthEntries = entries.filter {
                    Calendar.current.isDate($0.pluckedAt, equalTo: .now, toGranularity: .month)
                }
                Text("\(monthEntries.count) blossoms plucked")
                    .foregroundStyle(BloomPalette.textMuted)
                let completionRate = monthEntries.isEmpty ? 0 : Int((Double(monthEntries.filter { $0.status == .completed }.count) / Double(monthEntries.count)) * 100)
                Text("\(completionRate)% marked done")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(BloomPalette.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private func reload() {
        entries = (try? services.journalRepository.fetchAll()) ?? []
    }
}
