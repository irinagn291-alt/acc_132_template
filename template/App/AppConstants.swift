import Foundation

enum AppConstants {
    static let appName = "BloomPluck"
    static let contactURL = PortalConfig.contactURL
    static let privacyURL = PortalConfig.privacyURL
    static let maxBloomNameLength = 60
    static let maxPetalTitleLength = 100
    static let maxPetalDetailsLength = 240
    static let minPetals = 3
    static let maxPetals = 12
    static let hasCompletedOnboardingKey = "hasCompletedOnboarding"
    static let hasSeededBuiltInBloomsKey = "hasSeededBuiltInBlooms"
    static let defaultDailyBloomIdKey = "defaultDailyBloomId"
    static let soundEnabledKey = "soundEnabled"
    static let hapticsEnabledKey = "hapticsEnabled"
    static let reduceAnimationsKey = "reduceAnimations"
    static let allowRebloomKey = "allowRebloom"
}
