//
//  MapTab.swift
//  TapFrenzy
//
//  Created by Thimanjila Udangawe on 2026-07-10.
//

import SwiftUI
import MapKit

struct MapTab: View {
    @EnvironmentObject var sessionStore: SessionStore
    @State private var selectedSession: GameSession?

    private var validSessions: [GameSession] {
        sessionStore.sessions.filter { $0.latitude != 0 || $0.longitude != 0 }
    }

    var body: some View {
        Map {
            ForEach(validSessions) { session in
                Marker(
                    session.mode.rawValue,
                    coordinate: CLLocationCoordinate2D(latitude: session.latitude, longitude: session.longitude)
                )
                .tag(session.id)
            }
        }
        .navigationTitle("Map")
        .overlay(alignment: .bottom) {
            if validSessions.isEmpty {
                Text("Play a game to see it appear on the map.")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding()
                    .background(.black.opacity(0.6))
                    .cornerRadius(10)
                    .padding()
            }
        }
    }
}

#Preview {
    NavigationStack {
        MapTab()
            .environmentObject(SessionStore())
    }
}
