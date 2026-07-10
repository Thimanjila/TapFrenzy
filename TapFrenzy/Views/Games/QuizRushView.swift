//
//  QuizRushView.swift
//  TapFrenzy
//
//  Created by Thimanjila Udangawe on 2026-07-09.
//

import SwiftUI

struct QuizRushView: View {
    @StateObject private var viewModel = QuizViewModel()
    @State private var shakeTrigger: CGFloat = 0
    @EnvironmentObject var sessionStore: SessionStore
    @EnvironmentObject var locationService: LocationService
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .loading:
                loadingView
            case .failed:
                failedView
            case .loaded:
                questionView
            case .finished:
                finishedView
            }
        }
        .padding()
        .task {
                viewModel.configure(sessionStore: sessionStore, locationService: locationService)
                await viewModel.load()
                locationService.requestLocation()
            }
        }

    // Loading
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text("Loading questions...")
                .foregroundColor(.gray)
        }
    }

    // Failed
    private var failedView: some View {
        VStack(spacing: 16) {
            Text("Couldn't load questions")
                .font(.headline)
            Text("Check your connection and try again.")
                .font(.subheadline)
                .foregroundColor(.gray)

            Button("Retry") {
                Task { await viewModel.load() }
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 160)
            .background(Color.orange)
            .cornerRadius(12)
        }
    }

    // Loaded (active question)
    private var questionView: some View {
        VStack(spacing: 20) {
            HStack {
                Text("\(viewModel.currentIndex + 1) of \(viewModel.questions.count)")
                    .font(.headline)
                Spacer()
                Text("Streak: \(viewModel.streak)")
                    .font(.headline)
                    .foregroundColor(.orange)
            }

            Text("Score: \(viewModel.score)")
                .font(.title2.bold())

            if let question = viewModel.currentQuestion {
                Text(question.question)
                    .font(.title3.bold())
                    .multilineTextAlignment(.center)
                    .padding()

                ForEach(question.allAnswers, id: \.self) { answer in
                    Button(answer) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            viewModel.submitAnswer(answer)
                        }
                        if viewModel.wasCorrect == false {
                            withAnimation(.default) {
                                shakeTrigger += 1
                            }
                        }
                    }
                    .font(.body.bold())
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(buttonColour(for: answer))
                    .cornerRadius(10)
                    .disabled(viewModel.selectedAnswer != nil)
                }
            }

            if viewModel.selectedAnswer != nil {
                Button("Next") {
                    viewModel.advance()
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 160)
                .background(Color.blue)
                .cornerRadius(12)
            }
        }
        .modifier(ShakeEffect(animatableData: shakeTrigger))
        .background(
            (viewModel.wasCorrect == true ? Color.green : viewModel.wasCorrect == false ? Color.red : Color.clear)
                .opacity(0.15)
                .animation(.easeInOut(duration: 0.2), value: viewModel.wasCorrect)
        )
    }

    private func buttonColour(for answer: String) -> Color {
        guard let selected = viewModel.selectedAnswer else { return .yellow }
        if answer == viewModel.currentQuestion?.correct_answer {
            return .green
        }
        if answer == selected {
            return .red
        }
        return .gray.opacity(0.5)
    }

    // Finished
    private var finishedView: some View {
        VStack(spacing: 20) {
            Text("Quiz Complete!")
                .font(.largeTitle.bold())
            Text("Final Score: \(viewModel.score)")
                .font(.title)

            Button("Play Again") {
                viewModel.restart()
            }
            .font(.title2.bold())
            .foregroundColor(.white)
            .padding()
            .frame(width: 200)
            .background(Color.orange)
            .cornerRadius(12)
        }
    }
}

#Preview {
    QuizRushView()
}
