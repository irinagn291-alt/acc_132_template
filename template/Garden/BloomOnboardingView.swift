import SwiftUI

struct BloomOnboardingView: View {
    @EnvironmentObject private var services: BloomServices
    @State private var page = 0

    private let pages: [(icon: String, title: String, subtitle: String)] = [
        ("camera.macro", "Welcome to your garden", "BloomPluck turns gentle self-care into a petal-by-petal ritual."),
        ("leaf.fill", "Pluck one petal at a time", "Each bloom hides a soft prompt. Pull petals until your care message appears."),
        ("heart.fill", "Nurture your streak", "Small daily blooms build a blooming streak you can feel proud of."),
        ("book.closed.fill", "Keep a blossom journal", "Save what you revealed, mark it done, and revisit kind moments."),
        ("sparkles", "Begin your bloom", "Swipe through your garden anytime — no tab bar, just flowing pages.")
    ]

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("Skip") { finish() }
                    .foregroundStyle(BloomPalette.textMuted)
            }
            .padding(.horizontal, 20)

            TabView(selection: $page) {
                ForEach(pages.indices, id: \.self) { idx in
                    onboardingPage(pages[idx]).tag(idx)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))

            BloomPrimaryButton(page == pages.count - 1 ? "Enter the Garden" : "Continue", icon: "arrow.right") {
                if page == pages.count - 1 { finish() }
                else { withAnimation { page += 1 } }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .bloomScreen()
    }

    private func onboardingPage(_ item: (icon: String, title: String, subtitle: String)) -> some View {
        VStack(spacing: 28) {
            Spacer()
            ZStack {
                Circle()
                    .fill(BloomPalette.heroGradient)
                    .frame(width: 170, height: 170)
                Image(systemName: item.icon)
                    .font(.system(size: 58, weight: .semibold))
                    .foregroundStyle(.white)
            }
            VStack(spacing: 12) {
                Text(item.title).bloomSerifTitle(28).multilineTextAlignment(.center)
                Text(item.subtitle)
                    .font(.body)
                    .foregroundStyle(BloomPalette.textMuted)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            Spacer()
            Spacer()
        }
    }

    private func finish() {
        Task { @MainActor in
            services.preferences.hasCompletedOnboarding = true
        }
    }
}
