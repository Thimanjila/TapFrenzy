//
//  StatsTab.swift
//  TapFrenzy
//
//  Created by Thimanjila Udangawe on 2026-07-10.
//

import SwiftUI
import Charts

struct StatsTab: View {
    @EnvironmentObject var sessionStore: SessionStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                totalsSection
                bestsSection
                chartSection
                recentSection
            }
            .padding()
        }
        .navigationTitle("Stats")
    }

    // Totals
    private var totalsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Totals")
                .font(.headline)

            HStack {
                statBox(title: "Games Played", value: "\(sessionStore.sessions.count)")
                statBox(title: "Total Score", value: "\(sessionStore.sessions.map(\.score).reduce(0, +))")
            }
        }
    }

    private func statBox(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.title.bold())
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.15))
        .cornerRadius(12)
    }

    // Personal Bests
    private var bestsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Personal Bests")
                .font(.headline)

            ForEach(GameMode.allCases, id: \.self) { mode in
                HStack {
                    Text(mode.rawValue)
                    Spacer()
                    Text("\(sessionStore.bestScore(for: mode))")
                        .fontWeight(.bold)
                }
                .padding(.vertical, 4)
            }
        }
    }

    // Bar Chart
    private var chartSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Scores Over Time")
                .font(.headline)

            if sessionStore.sessions.isEmpty {
                Text("Play a game to see your chart here.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            } else {
                Chart(sessionStore.sessions) { session in
                    BarMark(
                        x: .value("Date", session.timestamp, unit: .minute),
                        y: .value("Score", session.score)
                    )
                    .foregroundStyle(by: .value("Mode", session.mode.rawValue))
                }
                .frame(height: 220)
            }
        }
    }

    // Recent Games
    private var recentSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recent Games")
                .font(.headline)

            if sessionStore.sessions.isEmpty {
                Text("No games played yet.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            } else {
                ForEach(sessionStore.sessions.sorted(by: { $0.timestamp > $1.timestamp }).prefix(10)) { session in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(session.mode.rawValue)
                                .fontWeight(.semibold)
                            Text(session.timestamp.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Text("\(session.score)")
                            .font(.headline)
                    }
                    .padding(.vertical, 4)
                    Divider()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        StatsTab()
            .environmentObject(SessionStore())
    }
}
