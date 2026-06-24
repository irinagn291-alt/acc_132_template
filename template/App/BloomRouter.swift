import SwiftUI

struct BloomRouter: View {
    @EnvironmentObject private var services: BloomServices

    var body: some View {
        if services.preferences.hasCompletedOnboarding {
            SwipeGardenNav()
        } else {
            BloomOnboardingView()
        }
    }
}
