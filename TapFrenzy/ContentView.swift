//
//  ContentView.swift
//  TapFrenzy
//
//  Created by Thimanjila Udangawe on 2026-07-07.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("Tap Frenzy").font(.largeTitle.bold())
            Text("Score: 0").font(.title.bold())
            Button("TAP") {}
                .frame(width: 150, height: 150)
                .background(Color.green)
                .clipShape(Circle())
        }
    }
}

#Preview {
    ContentView()
}
