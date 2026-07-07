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

    // Combo System
    @State private var comboMultiplier: Int = 1
    @State private var lastTapDate: Date? = nil

    // Trap Colour
    @State private var isBonusColour: Bool = true

    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    let trapColourTimer = Timer.publish(every: 1.5, on: .main, in: .common).autoconnect()

    var body: some View {
        if gameActive {
            gameView
        } else {
            gameOverView
        }
    }

    private var gameView: some View {
        VStack(spacing: 24) {
            Text("Tap Frenzy").font(.largeTitle.bold())
            Text("Score: \(score)").font(.title.bold())
            Text("Combo x\(comboMultiplier)")
                .font(.headline)
                .foregroundColor(.yellow)
            Text(String(format: "%.1fs", timeRemaining))
                .font(.title2.monospacedDigit())
                .foregroundColor(.gray)

            Button("TAP") {
                handleTap()
            }
            .frame(width: 150, height: 150)
            .background(isBonusColour ? Color.green : Color.gray)
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
        .onReceive(trapColourTimer) { _ in
            guard gameActive else { return }
            isBonusColour.toggle()
        }
    }

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

    // Logic
    private func handleTap() {
        let now = Date()
        if let last = lastTapDate, now.timeIntervalSince(last) <= 0.5 {
            comboMultiplier += 1
        } else {
            comboMultiplier = 1
        }
        lastTapDate = now

        var points = isBonusColour ? 1 : -1
        if points > 0 {
            points *= comboMultiplier
        }
        score = max(0, score + points)
    }

    private func endGame() {
        gameActive = false
    }

    private func resetGame() {
        score = 0
        timeRemaining = 10.0
        comboMultiplier = 1
        lastTapDate = nil
        isBonusColour = true
        gameActive = true
    }
}
#Preview {
    ContentView()
}
