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
    @State private var gameActive: Bool = false

    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        if gameActive {
            gameView
        } else {
            gameOverView
        }
    }

    //  Game Screen
    private var gameView: some View {
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
            guard gameActive else { return }
            if timeRemaining > 0 {
                timeRemaining -= 0.1
            } else {
                endGame()
            }
        }
    }

    // Game Over Screen
    private var gameOverView: some View {
        VStack(spacing: 20) {
            Text("Game Over").font(.largeTitle.bold())
            Text("Final Score: \(score)").font(.title)

            Button("Play Again") {
                resetGame()
            }
            .font(.title2.bold())
            .foregroundColor(.white)
            .padding()
            .frame(width: 200)
            .background(Color.green)
            .cornerRadius(12)
        }
    }

    //Logic
    private func endGame() {
        gameActive = false
    }

    private func resetGame() {
        score = 0
        timeRemaining = 10.0
        gameActive = true
    }
}

#Preview {
    ContentView()
}
