import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    UNUserNotificationCenter.current().delegate = self
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
          case "send", "schedule", "complete", "cancel":
            TimerNotifications.handle(call, result: result)
          default: result(FlutterMethodNotImplemented)
          }
        }
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func userNotificationCenter(_ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    if notification.request.identifier.hasPrefix("ptune.timer.") {
      completionHandler([.banner, .list, .sound])
    } else {
      super.userNotificationCenter(center, willPresent: notification, withCompletionHandler: completionHandler)
    }
  }
}

private enum TimerNotifications {
  static let center = UNUserNotificationCenter.current()
  static let defaults = UserDefaults.standard
  static let pendingKey = "ptune.timer.pending"
  static let dueKey = "ptune.timer.due"
  static let handledKey = "ptune.timer.handled"

  static func cancel(preserveDue: Bool = false) {
    if let id = defaults.string(forKey: pendingKey) {
      let due = defaults.double(forKey: dueKey) <= Date().timeIntervalSince1970
      if due {
        defaults.set(id, forKey: handledKey)
      }
      if !preserveDue || !due {
        center.removePendingNotificationRequests(withIdentifiers: ["ptune.timer." + id])
      }
    }
    defaults.removeObject(forKey: pendingKey)
    defaults.removeObject(forKey: dueKey)
  }

  static func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "cancel" { cancel(); result(nil); return }
    let args = call.arguments as? [String: Any] ?? [:]
    let id = args["sessionId"] as? String ?? UUID().uuidString
    let content = UNMutableNotificationContent()
    content.title = args["title"] as? String ?? ""
    content.body = args["body"] as? String ?? ""
    content.sound = .default
    var trigger: UNNotificationTrigger? = nil
    if call.method == "schedule" {
      cancel()
      if defaults.string(forKey: handledKey) == id { result(nil); return }
      let at = (args["at"] as? NSNumber)?.doubleValue ?? 0
      let due = at / 1000
      guard due > Date().timeIntervalSince1970 else { result(nil); return }
      defaults.set(id, forKey: pendingKey)
      defaults.set(due, forKey: dueKey)
      trigger = UNTimeIntervalNotificationTrigger(timeInterval: max(0.001, due - Date().timeIntervalSince1970), repeats: false)
    } else if call.method == "complete" {
      cancel(preserveDue: true)
      if defaults.string(forKey: handledKey) == id { result(nil); return }
      defaults.set(id, forKey: handledKey)
    }
    let request = UNNotificationRequest(identifier: "ptune.timer." + id, content: content, trigger: trigger)
    center.add(request) { error in
      DispatchQueue.main.async {
        if let error = error {
          if call.method == "schedule" { cancel() }
          result(FlutterError(code: "notification_error", message: error.localizedDescription, details: nil))
        } else { result(nil) }
      }
    }
  }
}
