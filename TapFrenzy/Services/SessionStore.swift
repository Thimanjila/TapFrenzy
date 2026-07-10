//
//  SessionStore.swift
//  TapFrenzy
//
//  Created by Thimanjila Udangawe on 2026-07-10.
//

import Foundation

@MainActor
class SessionStore: ObservableObject {
    @Published private(set) var sessions: [GameSession] = []

    private let storageKey = "gameSessions"

    init() {
        load()
    }

    func addSession(mode: GameMode, score: Int, latitude: Double = 0, longitude: Double = 0) {
        let session = GameSession(mode: mode, score: score, latitude: latitude, longitude: longitude)
        sessions.append(session)
        save()
    }

    func sessions(for mode: GameMode) -> [GameSession] {
        sessions.filter { $0.mode == mode }
    }

    func bestScore(for mode: GameMode) -> Int {
        sessions(for: mode).map(\.score).max() ?? 0
    }

    func resetAll() {
        sessions = []
        save()
    }

    private func save() {
        if let data = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([GameSession].self, from: data) else {
            return
        }
        sessions = decoded
    }
}
