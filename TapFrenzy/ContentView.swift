//
//  ContentView.swift
//  TapFrenzy
//
//  Created by Thimanjila Udangawe on 2026-07-07.
//

import SwiftUI

struct ContentView: View {
    @State private var score: Int = 0
    @State private var timeRemaining: Double = 10.0

    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 24) {
            Text("Tap Frenzy").font(.largeTitle.bold())
            Text("Score: \(score)").font(.title.bold())
            Text(String(format: "%.1fs", timeRemaining))
                .font(.title2.monospacedDigit())
                .foregroundColor(.gray)

            Button("TAP") {
                score += 1
            }
            .frame(width: 150, height: 150)
            .background(Color.green)
            .clipShape(Circle())
        }
        .onReceive(timer) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 0.1
            }
        }
    }
}

#Preview {
    ContentView()
}
