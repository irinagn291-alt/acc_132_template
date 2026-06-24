import SwiftUI
import SwiftData

struct BlossomArchive: View {
    @EnvironmentObject private var services: BloomServices
    @State private var blooms: [BloomSet] = []
    @State private var selectedBloom: BloomSet?
    @State private var showEditor = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 14) {
                    BloomSectionHeader(
                        title: "Blossom Archive",
                        subtitle: "Curated and custom bloom packs"
                    )
                    .padding(.horizontal, 16)

                    if blooms.isEmpty {
                        BloomEmptyState(
                            icon: "camera.macro",
                            title: "No blossoms",
                            message: "Your bloom library will appear here."
                        )
                    } else {
                        ForEach(blooms) { bloom in
                            Button { selectedBloom = bloom } label: {
                                archiveRow(bloom)
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal, 16)
                        }
                    }
                }
                .padding(.vertical, 12)
            }
            .bloomScreen()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showEditor = true } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(BloomPalette.primary)
                    }
                }
            }
            .navigationDestination(isPresented: Binding(
                get: { selectedBloom != nil },
                set: { if !$0 { selectedBloom = nil } }
            )) {
                if let bloom = selectedBloom {
                    BlossomPluckView(bloomSet: bloom)
                }
            }
            .sheet(isPresented: $showEditor) {
                BloomEditorView()
            }
            .onAppear { reload() }
        }
    }

    private func archiveRow(_ bloom: BloomSet) -> some View {
        SoftGlassCard {
            HStack(spacing: 12) {
                Image(systemName: bloom.category.icon)
                    .font(.title3)
                    .foregroundStyle(BloomPalette.primary)
                    .frame(width: 36)
                VStack(alignment: .leading, spacing: 4) {
                    Text(bloom.name).bloomSerifTitle(18)
                    Text(bloom.isBuiltIn ? "Built-in · \(bloom.sortedPetals.count) petals" : "Custom · \(bloom.sortedPetals.count) petals")
                        .font(.caption)
                        .foregroundStyle(BloomPalette.textMuted)
                }
                Spacer()
            }
        }
    }

    private func reload() {
        blooms = (try? services.bloomRepository.fetchAll()) ?? []
    }
}

struct BloomEditorView: View {
    @EnvironmentObject private var services: BloomServices
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var description = ""
    @State private var category: BloomCategory = .selfCare
    @State private var petals: [String] = ["", "", ""]

    var body: some View {
        NavigationStack {
            Form {
                Section("Bloom") {
                    TextField("Name", text: $name)
                    TextField("Description", text: $description)
                    Picker("Category", selection: $category) {
                        ForEach(BloomCategory.allCases) { cat in
                            Text(cat.rawValue).tag(cat)
                        }
                    }
                }
                Section("Petals") {
                    ForEach(petals.indices, id: \.self) { index in
                        TextField("Petal \(index + 1)", text: $petals[index])
                    }
                    if petals.count < AppConstants.maxPetals {
                        Button("Add petal") { petals.append("") }
                    }
                }
            }
            .navigationTitle("New Bloom")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(!canSave)
                }
            }
        }
    }

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        petals.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }.count >= AppConstants.minPetals
    }

    private func save() {
        let bloom = BloomSet(name: name, bloomDescription: description, category: category)
        bloom.petals = petals
            .enumerated()
            .compactMap { index, title in
                let trimmed = title.trimmingCharacters(in: .whitespaces)
                guard !trimmed.isEmpty else { return nil }
                return PetalChoice(title: trimmed, sortOrder: index)
            }
        try? services.bloomRepository.save(bloom)
        dismiss()
    }
}
