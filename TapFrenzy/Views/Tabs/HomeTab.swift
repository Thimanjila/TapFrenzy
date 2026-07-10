//
//  HomeView.swift
//  TapFrenzy
//
//  Created by Thimanjila Udangawe on 2026-07-07.
//

import SwiftUI

struct HomeTab: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Choose a Game")
                    .font(.largeTitle.bold())
                    .padding(.bottom, 20)

                NavigationLink(destination: TapFrenzyView()) {
                    Text("Tap Frenzy")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                }

                NavigationLink(destination: LightItUpView()) {
                    Text("Light It Up")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                
                
                NavigationLink(destination: QuizRushView()) {
                                    Text("Quiz Rush")
                                        .font(.title2.bold())
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.orange)
                                        .cornerRadius(12)
                                }
                NavigationLink(destination: SettingsTab()) {
                    Text("Settings")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(12)
                }
            }
            .padding(40)
        }
    }
}

#Preview {
    HomeTab()
}
