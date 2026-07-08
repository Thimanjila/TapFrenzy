//
//  LightItUpView.swift
//  TapFrenzy
//
//  Created by Thimanjila Udangawe on 2026-07-07.
//

import SwiftUI

enum GameLevel: CaseIterable {
    case l1, l2, l3, l4

    var cardCount: Int {
        switch self {
        case .l1: return 3
        case .l2: return 4
        case .l3: return 6
        case .l4: return 9
        }
    }

    var litWindow: Double {
        switch self {
        case .l1: return 1.5
        case .l2: return 1.2
        case .l3: return 1.0
        case .l4: return 0.8
        }
    }

    var litCardCount: Int {
        self == .l4 ? 2 : 1
    }

    var columns: Int {
        switch self {
        case .l1: return 3
        case .l2: return 4
        case .l3: return 3
        case .l4: return 3
        }
    }
}

struct LightItUpView: View {
    @State private var cards: [Card] = []
    @State private var score: Int = 0
    @State private var timeRemaining: Double = 60.0
    @State private var gameActive: Bool = false
    @State private var currentLevel: GameLevel = .l1
    @AppStorage("lightItUpHighScore") private var highScore: Int = 0

    let roundTimer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var lightTimerCancellable: Timer? = nil

    var body: some View {
        VStack(spacing: 24) {
            if gameActive {
                Text("Light It Up").font(.largeTitle.bold())
                Text("Score: \(score)").font(.title.bold())
                Text(String(format: "%.1fs", timeRemaining))
                    .font(.title2.monospacedDigit())
                    .foregroundColor(.gray)

                LazyVGrid(columns: gridColumns, spacing: 16) {
                    ForEach(cards) { card in
                        RoundedRectangle(cornerRadius: 12)
                            .fill(card.isLit ? Color.yellow : Color.gray.opacity(0.3))
                            .frame(height: 80)
                            .scaleEffect(card.isLit ? 1.05 : 1.0)
                            .onTapGesture {
                                handleTap(on: card)
                            }
                    }
                }
                .padding()
            } else {
                Text("Light It Up").font(.largeTitle.bold())
                Text("Final Score: \(score)").font(.title)

                if score >= highScore && score > 0 {
                    Text(" New High Score!")
                        .foregroundColor(.yellow)
                        .font(.headline)
                } else {
                    Text("High Score: \(highScore)")
                        .foregroundColor(.gray)
                }

                Button("Start") {
                    startGame()
                }
                .font(.title2.bold())
                .foregroundColor(.white)
                .padding()
                .frame(width: 200)
                .background(Color.blue)
                .cornerRadius(12)
            }
        }
        .onReceive(roundTimer) { _ in
            guard gameActive else { return }
            timeRemaining -= 0.1
            updateLevel()
            if timeRemaining <= 0 {
                endGame()
            }
        }
        .onAppear {
            setupCards(count: currentLevel.cardCount)
        }
    }

    private var gridColumns: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: currentLevel.columns)
    }

    private func setupCards(count: Int) {
        cards = (0..<count).map { Card(id: $0) }
    }

    private func updateLevel() {
        let elapsed = 60.0 - timeRemaining
        let newLevel: GameLevel
        switch elapsed {
        case 0..<15: newLevel = .l1
        case 15..<30: newLevel = .l2
        case 30..<45: newLevel = .l3
        default: newLevel = .l4
        }

        if newLevel != currentLevel {
            currentLevel = newLevel
            setupCards(count: currentLevel.cardCount)
            restartLightTimer()
        }
    }

    private func restartLightTimer() {
        lightTimerCancellable?.invalidate()
        lightTimerCancellable = Timer.scheduledTimer(withTimeInterval: currentLevel.litWindow, repeats: true) { _ in
            lightRandomCards()
        }
    }

    private func lightRandomCards() {
        withAnimation {
            for i in cards.indices { cards[i].isLit = false }
            let indicesToLight = cards.indices.shuffled().prefix(currentLevel.litCardCount)
            for i in indicesToLight { cards[i].isLit = true }
        }
    }

    private func handleTap(on card: Card) {
        guard let index = cards.firstIndex(where: { $0.id == card.id }) else { return }

        if cards[index].isLit {
            score += 1
            withAnimation { cards[index].isLit = false }
        } else {
            score = max(0, score - 1)
        }
    }

    private func startGame() {
        score = 0
        timeRemaining = 60.0
        currentLevel = .l1
        setupCards(count: currentLevel.cardCount)
        gameActive = true
        restartLightTimer()
    }

    private func endGame() {
        gameActive = false
        lightTimerCancellable?.invalidate()
        if score > highScore {
                highScore = score
            }
    }
}
#Preview {
    LightItUpView()
}
