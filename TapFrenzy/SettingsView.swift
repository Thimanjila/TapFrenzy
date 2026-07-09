//
//  SettingsView.swift
//  TapFrenzy
//
//  Created by Thimanjila Udangawe on 2026-07-09.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("roundLength") private var roundLength: Double = 60.0

    let options: [Double] = [30, 60, 90]

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Round Length")
                    .font(.title.bold())

                Picker("Round Length", selection: $roundLength) {
                    ForEach(options, id: \.self) { value in
                        Text("\(Int(value))s").tag(value)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                Text("Applies to Light It Up rounds.")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Spacer()
            }
            .padding()
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
