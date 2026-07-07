//
//  LightItUpView.swift
//  TapFrenzy
//
//  Created by Thimanjila Udangawe on 2026-07-07.
//

import SwiftUI

struct LightItUpView: View {
    @State private var cards: [Card] = (0..<9).map { Card(id: $0) }
    @State private var score: Int = 0

    let lightTimer = Timer.publish(every: 1.5, on: .main, in: .common).autoconnect()

    let columns = [
        GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())
    ]

    var body: some View {
        VStack(spacing: 24) {
            Text("Light It Up")
                .font(.largeTitle.bold())

            Text("Score: \(score)")
                .font(.title.bold())

            LazyVGrid(columns: columns, spacing: 16) {
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
        }
        .onReceive(lightTimer) { _ in
            lightRandomCard()
        }
    }

    private func lightRandomCard() {
        withAnimation {
            for i in cards.indices { cards[i].isLit = false }
            if let randomIndex = cards.indices.randomElement() {
                cards[randomIndex].isLit = true
            }
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
}

#Preview {
    LightItUpView()
}
