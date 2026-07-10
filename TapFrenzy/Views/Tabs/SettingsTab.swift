//
//  SettingsView.swift
//  TapFrenzy
//
//  Created by Thimanjila Udangawe on 2026-07-09.
//

import SwiftUI

struct SettingsTab: View {
    @EnvironmentObject var notificationService: NotificationService
    @EnvironmentObject var sessionStore: SessionStore

    @AppStorage("roundLength") private var roundLength: Double = 60.0
    @AppStorage("dailyChallengeEnabled") private var dailyChallengeEnabled: Bool = false
    @AppStorage("dailyChallengeHour") private var dailyChallengeHour: Int = 18
    @AppStorage("dailyChallengeMinute") private var dailyChallengeMinute: Int = 0

    @State private var showResetConfirmation = false

    let roundOptions: [Double] = [30, 60, 90]

    var body: some View {
        Form {
            Section("Round Length") {
                Picker("Light It Up Round Length", selection: $roundLength) {
                    ForEach(roundOptions, id: \.self) { value in
                        Text("\(Int(value))s").tag(value)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section("Daily Challenge") {
                Toggle("Enable Daily Reminder", isOn: $dailyChallengeEnabled)
                    .onChange(of: dailyChallengeEnabled) { _, isOn in
                        if isOn {
                            notificationService.requestPermission()
                            scheduleFromStoredTime()
                        } else {
                            notificationService.cancelDailyChallenge()
                        }
                    }

                if dailyChallengeEnabled {
                    DatePicker(
                        "Reminder Time",
                        selection: dailyChallengeTimeBinding,
                        displayedComponents: .hourAndMinute
                    )
                    .onChange(of: dailyChallengeHour) { _, _ in scheduleFromStoredTime() }
                    .onChange(of: dailyChallengeMinute) { _, _ in scheduleFromStoredTime() }
                }
            }

            Section {
                Button("Reset All Stats", role: .destructive) {
                    showResetConfirmation = true
                }
            }
        }
        .navigationTitle("Settings")
        .confirmationDialog(
            "Reset all stats?",
            isPresented: $showResetConfirmation,
            titleVisibility: .visible
        ) {
            Button("Reset Everything", role: .destructive) {
                sessionStore.resetAll()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This deletes every recorded game session and cannot be undone.")
        }
    }

    private var dailyChallengeTimeBinding: Binding<Date> {
        Binding(
            get: {
                var components = DateComponents()
                components.hour = dailyChallengeHour
                components.minute = dailyChallengeMinute
                return Calendar.current.date(from: components) ?? Date()
            },
            set: { newValue in
                let components = Calendar.current.dateComponents([.hour, .minute], from: newValue)
                dailyChallengeHour = components.hour ?? 18
                dailyChallengeMinute = components.minute ?? 0
            }
        )
    }

    private func scheduleFromStoredTime() {
        var components = DateComponents()
        components.hour = dailyChallengeHour
        components.minute = dailyChallengeMinute
        if let date = Calendar.current.date(from: components) {
            notificationService.scheduleDailyChallenge(at: date)
        }
    }
}

#Preview {
    NavigationStack {
        SettingsTab()
            .environmentObject(NotificationService())
            .environmentObject(SessionStore())
    }
}
