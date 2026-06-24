import SwiftUI
import SwiftData

struct GardenSettingsView: View {
    @EnvironmentObject private var services: BloomServices
    @Environment(\.modelContext) private var modelContext
    @State private var blooms: [BloomSet] = []
    @State private var showDeleteJournalConfirm = false
    @State private var showResetBuiltInConfirm = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    BloomSectionHeader(title: "Self-Care Settings", subtitle: "Tune your garden experience")
                        .padding(.horizontal, 16)

                    settingsSection("Experience") {
                        VStack(spacing: 0) {
                            toggleRow("Haptic Petals", "waveform", \.hapticsEnabled)
                            divider
                            toggleRow("Reduce Animations", "tortoise.fill", \.reduceAnimations)
                            divider
                            toggleRow("Allow Rebloom", "arrow.clockwise", \.allowRebloom)
                        }
                    }

                    settingsSection("Daily Bloom") {
                        dailyBloomPicker
                    }

                    settingsSection("Garden Data") {
                        VStack(spacing: 0) {
                            actionRow("Reset Built-in Blooms", "arrow.clockwise") {
                                showResetBuiltInConfirm = true
                            }
                            divider
                            actionRow("Clear Journal", "trash.fill", danger: true) {
                                showDeleteJournalConfirm = true
                            }
                        }
                    }

                    settingsSection("About") {
                        VStack(spacing: 0) {
                            infoRow("Version", Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                            divider
                            NavigationLink { PortalPrivacyView() } label: {
                                actionLabel("Privacy Policy", "hand.raised.fill")
                            }
                            divider
                            NavigationLink { PortalContactView() } label: {
                                actionLabel("Contact", "envelope.fill")
                            }
                        }
                    }
                }
                .padding(.vertical, 12)
            }
            .bloomScreen()
            .onAppear { blooms = (try? services.bloomRepository.fetchAll()) ?? [] }
            .alert("Clear journal?", isPresented: $showDeleteJournalConfirm) {
                Button("Delete", role: .destructive) {
                    try? services.journalRepository.deleteAll()
                }
                Button("Cancel", role: .cancel) {}
            }
            .alert("Reset built-in blooms?", isPresented: $showResetBuiltInConfirm) {
                Button("Reset", role: .destructive) {
                    try? BuiltInBloomSeeder.resetBuiltIn(context: modelContext)
                    blooms = (try? services.bloomRepository.fetchAll()) ?? []
                }
                Button("Cancel", role: .cancel) {}
            }
        }
    }

    @ViewBuilder
    private func settingsSection<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(BloomPalette.textMuted)
                .padding(.horizontal, 20)
            SoftGlassCard { content() }
                .padding(.horizontal, 16)
        }
    }

    private var divider: some View {
        Divider().padding(.leading, 48)
    }

    private func toggleRow(_ title: String, _ icon: String, _ keyPath: ReferenceWritableKeyPath<BloomPreferences, Bool>) -> some View {
        Toggle(isOn: binding(keyPath)) {
            HStack(spacing: 12) {
                Image(systemName: icon).frame(width: 24).foregroundStyle(BloomPalette.primary)
                Text(title)
            }
        }
        .tint(BloomPalette.primary)
        .padding(.vertical, 10)
    }

    private var dailyBloomPicker: some View {
        Picker("Default bloom", selection: bindingOptional(\.defaultDailyBloomId)) {
            Text("Auto").tag(UUID?.none)
            ForEach(blooms) { bloom in
                Text(bloom.name).tag(Optional(bloom.id))
            }
        }
        .padding(.vertical, 8)
    }

    private func actionRow(_ title: String, _ icon: String, danger: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            actionLabel(title, icon, danger: danger)
        }
        .padding(.vertical, 10)
    }

    private func actionLabel(_ title: String, _ icon: String, danger: Bool = false) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 24)
                .foregroundStyle(danger ? BloomPalette.danger : BloomPalette.primary)
            Text(title)
                .foregroundStyle(danger ? BloomPalette.danger : BloomPalette.text)
            Spacer()
        }
    }

    private func infoRow(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value).foregroundStyle(BloomPalette.textMuted)
        }
        .padding(.vertical, 10)
    }

    private func binding(_ keyPath: ReferenceWritableKeyPath<BloomPreferences, Bool>) -> Binding<Bool> {
        Binding(
            get: { services.preferences[keyPath: keyPath] },
            set: { services.preferences[keyPath: keyPath] = $0 }
        )
    }

    private func bindingOptional(_ keyPath: ReferenceWritableKeyPath<BloomPreferences, UUID?>) -> Binding<UUID?> {
        Binding(
            get: { services.preferences[keyPath: keyPath] },
            set: { services.preferences[keyPath: keyPath] = $0 }
        )
    }
}

enum BloomLegalType {
    case privacyPolicy, terms
}

struct BloomLegalView: View {
    let type: BloomLegalType

    var body: some View {
        ScrollView {
            Text(legalText)
                .font(.body)
                .foregroundStyle(BloomPalette.text)
                .padding()
        }
        .bloomScreen()
        .navigationTitle(type == .privacyPolicy ? "Privacy" : "Terms")
    }

    private var legalText: String {
        """
        \(AppConstants.appName) respects your privacy. We store bloom packs and journal entries locally on your device. \
        We do not sell personal data.
        """
    }
}

struct BloomContactView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("We would love to hear from you")
                .bloomSerifTitle(22)
                .multilineTextAlignment(.center)
            if let url = URL(string: AppConstants.contactURL) {
                Link("Open Contact Page", destination: url)
                    .font(.headline)
                    .foregroundStyle(BloomPalette.primary)
            }
        }
        .padding()
        .bloomScreen()
        .navigationTitle("Contact")
    }
}
