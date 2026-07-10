//
//  TapFrenzyApp.swift
//  TapFrenzy
//
//  Created by Thimanjila Udangawe on 2026-07-07.
//

import SwiftUI

@main
struct TapFrenzyApp: App {
    @StateObject private var sessionStore = SessionStore()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(sessionStore)
        }
    }
}
