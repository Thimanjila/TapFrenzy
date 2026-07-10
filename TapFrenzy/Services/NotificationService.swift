//
//  NotificationService.swift
//  TapFrenzy
//
//  Created by Thimanjila Udangawe on 2026-07-10.
//

import Foundation
import UserNotifications

@MainActor
class NotificationService: ObservableObject {
    @Published var isAuthorized: Bool = false

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            Task { @MainActor in
                self.isAuthorized = granted
            }
        }
    }

    func scheduleDailyChallenge(at time: Date) {
        let center = UNUserNotificationCenter.current()

        center.removePendingNotificationRequests(withIdentifiers: ["dailyChallenge"])

        let content = UNMutableNotificationContent()
        content.title = "Daily Challenge"
        content.body = "Your daily PlayHub challenge is ready. Come beat your best score!"
        content.sound = .default

        var components = Calendar.current.dateComponents([.hour, .minute], from: time)
        components.second = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyChallenge", content: content, trigger: trigger)

        center.add(request)
    }

    func cancelDailyChallenge() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyChallenge"])
    }
}
