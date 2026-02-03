import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()
    private init() {}

    func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { ok, _ in
            DispatchQueue.main.async { completion(ok) }
        }
    }

    func scheduleReminder(id: String, title: String, body: String, inMinutes: Double) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: inMinutes * 60, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
