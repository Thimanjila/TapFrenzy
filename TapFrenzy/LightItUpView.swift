//
//  LightItUpView.swift
//  TapFrenzy
//
//  Created by Thimanjila Udangawe on 2026-07-07.
//

import SwiftUI

struct LightItUpView: View {
    @State private var cards: [Card] = (0..<9).map { Card(id: $0) }

    let columns = [
        GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())
    ]

    var body: some View {
        VStack(spacing: 24) {
            Text("Light It Up")
                .font(.largeTitle.bold())

            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(cards) { card in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(card.isLit ? Color.yellow : Color.gray.opacity(0.3))
                        .frame(height: 80)
                        .scaleEffect(card.isLit ? 1.05 : 1.0)
                }
            }
            .padding()
        }
    }
}

#Preview {
    LightItUpView()
}
