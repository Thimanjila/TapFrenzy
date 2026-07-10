//
//  RootTabView.swift
//  TapFrenzy
//
//  Created by Thimanjila Udangawe on 2026-07-10.
//

import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeTab()
            }
            .tabItem {
                Label("Home", systemImage: "gamecontroller")
            }

            NavigationStack {
                StatsTab()
            }
            .tabItem {
                Label("Stats", systemImage: "chart.bar")
            }

            NavigationStack {
                MapTab()
            }
            .tabItem {
                Label("Map", systemImage: "map")
            }

            NavigationStack {
                SettingsTab()
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
    }
}

#Preview {
    RootTabView()
        .environmentObject(SessionStore())
}
