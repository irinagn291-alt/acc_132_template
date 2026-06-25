import UIKit
import OneSignalFramework

final class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        OneSignal.initialize("31244132-f52d-4f9a-84ba-795f8e3499f8", withLaunchOptions: launchOptions)
        OneSignal.Notifications.requestPermission({ _ in }, fallbackToSettings: false)
        application.registerForRemoteNotifications()
        return true
    }
}
