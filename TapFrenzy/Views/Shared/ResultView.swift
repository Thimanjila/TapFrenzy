//
//  ResultView.swift
//  TapFrenzy
//
//  Created by Thimanjila Udangawe on 2026-07-10.
//

import SwiftUI

struct ResultView: View {
    let mode: GameMode
    let score: Int
    let highScore: Int
    let onPlayAgain: () -> Void

    private var shareMessage: String {
        "I just scored \(score) on \(mode.rawValue) — beat that!"
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("\(mode.rawValue) Complete")
                .font(.largeTitle.bold())

            Text("Final Score: \(score)")
                .font(.title)

            if score >= highScore && score > 0 {
                Text(" New High Score!")
                    .foregroundColor(.yellow)
                    .font(.headline)
            } else {
                Text("High Score: \(highScore)")
                    .foregroundColor(.gray)
            }

            ShareLink(item: shareMessage) {
                Label("Share Score", systemImage: "square.and.arrow.up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 200)
                    .background(Color.purple)
                    .cornerRadius(12)
            }

            Button("Play Again") {
                onPlayAgain()
            }
            .font(.title2.bold())
            .foregroundColor(.white)
            .padding()
            .frame(width: 200)
            .background(Color.green)
            .cornerRadius(12)
        }
    }
}

#Preview {
    ResultView(mode: .tapFrenzy, score: 47, highScore: 40, onPlayAgain: {})
}
