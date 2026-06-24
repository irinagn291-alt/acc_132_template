import Foundation

@MainActor
final class BloomPreferences: ObservableObject {
    @Published var soundEnabled: Bool {
        didSet { UserDefaults.standard.set(soundEnabled, forKey: AppConstants.soundEnabledKey) }
    }
    @Published var hapticsEnabled: Bool {
        didSet { UserDefaults.standard.set(hapticsEnabled, forKey: AppConstants.hapticsEnabledKey) }
    }
    @Published var reduceAnimations: Bool {
        didSet { UserDefaults.standard.set(reduceAnimations, forKey: AppConstants.reduceAnimationsKey) }
    }
    @Published var allowRebloom: Bool {
        didSet { UserDefaults.standard.set(allowRebloom, forKey: AppConstants.allowRebloomKey) }
    }
    @Published var defaultDailyBloomId: UUID? {
        didSet {
            if let id = defaultDailyBloomId {
                UserDefaults.standard.set(id.uuidString, forKey: AppConstants.defaultDailyBloomIdKey)
            } else {
                UserDefaults.standard.removeObject(forKey: AppConstants.defaultDailyBloomIdKey)
            }
        }
    }
    @Published var hasCompletedOnboarding: Bool {
        didSet { UserDefaults.standard.set(hasCompletedOnboarding, forKey: AppConstants.hasCompletedOnboardingKey) }
    }

    init() {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: AppConstants.soundEnabledKey) == nil {
            defaults.set(true, forKey: AppConstants.soundEnabledKey)
        }
        if defaults.object(forKey: AppConstants.hapticsEnabledKey) == nil {
            defaults.set(true, forKey: AppConstants.hapticsEnabledKey)
        }
        if defaults.object(forKey: AppConstants.allowRebloomKey) == nil {
            defaults.set(true, forKey: AppConstants.allowRebloomKey)
        }
        soundEnabled = defaults.bool(forKey: AppConstants.soundEnabledKey)
        hapticsEnabled = defaults.bool(forKey: AppConstants.hapticsEnabledKey)
        reduceAnimations = defaults.bool(forKey: AppConstants.reduceAnimationsKey)
        allowRebloom = defaults.bool(forKey: AppConstants.allowRebloomKey)
        if let idString = defaults.string(forKey: AppConstants.defaultDailyBloomIdKey) {
            defaultDailyBloomId = UUID(uuidString: idString)
        }
        hasCompletedOnboarding = defaults.bool(forKey: AppConstants.hasCompletedOnboardingKey)
    }
}
