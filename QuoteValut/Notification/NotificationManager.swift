import UserNotifications

final class NotificationManager {

    static let shared = NotificationManager()
    private init() {}

    func requestPermission() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    func scheduleDailyQuote(
        quote: Quote,
        hour: Int,
        minute: Int
    ) {
        let content = UNMutableNotificationContent()
        content.title = "Daily Inspiration"
        content.body = "“\(quote.text)” — \(quote.author)"

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: "daily_quote",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: ["daily_quote"])

        UNUserNotificationCenter.current().add(request)
    }
}
