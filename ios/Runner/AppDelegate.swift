import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    if let controller = window?.rootViewController as? FlutterViewController {
      FlutterMethodChannel(name: "ptune/notification_permissions", binaryMessenger: controller.binaryMessenger)
        .setMethodCallHandler { call, result in
          switch call.method {
          case "status":
            UNUserNotificationCenter.current().getNotificationSettings { settings in
              let allowed = settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional
              DispatchQueue.main.async {
                result(["allowed": allowed, "exactRequired": false, "exactAllowed": true])
              }
            }
          case "request":
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, error in
              DispatchQueue.main.async {
                if let error = error { result(FlutterError(code: "permission_error", message: error.localizedDescription, details: nil)) }
                else { result(nil) }
              }
            }
          case "settings":
            if let url = URL(string: UIApplication.openSettingsURLString) {
              UIApplication.shared.open(url) { success in
                if success { result(nil) }
                else { result(FlutterError(code: "settings_error", message: "設定を開けませんでした", details: nil)) }
              }
            } else { result(FlutterError(code: "settings_error", message: "設定を開けませんでした", details: nil)) }
          default: result(FlutterMethodNotImplemented)
          }
        }
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
