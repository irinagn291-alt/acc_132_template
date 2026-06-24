import SwiftUI

enum GardenPage: Int, CaseIterable, Identifiable {
    case garden, archive, journal, insights, settings

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .garden: "Garden"
        case .archive: "Blooms"
        case .journal: "Journal"
        case .insights: "Insights"
        case .settings: "Care"
        }
    }

    var icon: String {
        switch self {
        case .garden: "leaf.fill"
        case .archive: "camera.macro"
        case .journal: "book.closed.fill"
        case .insights: "chart.line.uptrend.xyaxis"
        case .settings: "heart.text.square.fill"
        }
    }
}

struct SwipeGardenNav: View {
    @EnvironmentObject private var services: BloomServices
    @State private var page = 0

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $page) {
                GardenFlowView().tag(0)
                BlossomArchive().tag(1)
                GardenJournalView().tag(2)
                GardenInsightsView().tag(3)
                GardenSettingsView().tag(4)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut(duration: 0.25), value: page)

            gardenPageIndicator
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                .padding(.top, 6)
        }
        .bloomScreen()
    }

    private var gardenPageIndicator: some View {
        HStack(spacing: 0) {
            ForEach(GardenPage.allCases) { item in
                Button {
                    withAnimation { page = item.rawValue }
                    BloomHaptics.shared.selection()
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: item.icon)
                            .font(.system(size: 16, weight: page == item.rawValue ? .bold : .regular))
                        Text(item.title)
                            .font(.system(size: 10, weight: .medium))
                    }
                    .foregroundStyle(page == item.rawValue ? BloomPalette.text : BloomPalette.textMuted)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(
                        page == item.rawValue
                            ? BloomPalette.surface.opacity(0.55)
                            : Color.clear,
                        in: RoundedRectangle(cornerRadius: 14, style: .continuous)
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(6)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}
