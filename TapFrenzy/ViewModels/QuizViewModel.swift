//
//  QuizViewModel.swift
//  TapFrenzy
//
//  Created by Thimanjila Udangawe on 2026-07-09.
//

import Foundation

enum QuizState {
    case loading
    case loaded
    case failed
    case finished
}

@MainActor
class QuizViewModel: ObservableObject {
    @Published var questions: [Question] = []
    @Published var currentIndex: Int = 0
    @Published var score: Int = 0
    @Published var streak: Int = 0
    @Published var state: QuizState = .loading
    @Published var selectedAnswer: String? = nil
    @Published var wasCorrect: Bool? = nil

    private let service = TriviaService()
        private var sessionStore: SessionStore?
        private var locationService: LocationService?

    func configure(sessionStore: SessionStore, locationService: LocationService) {
        self.sessionStore = sessionStore
        self.locationService = locationService
    }

    var currentQuestion: Question? {
        guard currentIndex < questions.count else { return nil }
        return questions[currentIndex]
    }

    func load() async {
        state = .loading
        do {
            let fetched = try await service.fetchQuestions()
            questions = fetched
            currentIndex = 0
            score = 0
            streak = 0
            state = .loaded
        } catch {
            state = .failed
        }
    }

    func submitAnswer(_ answer: String) {
        guard let question = currentQuestion else { return }
        selectedAnswer = answer

        if answer == question.correct_answer {
            wasCorrect = true
            streak += 1
            let streakBonus = streak >= 3 ? 2 : 0
            score += 1 + streakBonus
        } else {
            wasCorrect = false
            streak = 0
            score = max(0, score - 1)
        }
    }

    func advance() {
        selectedAnswer = nil
        wasCorrect = nil

        if currentIndex + 1 < questions.count {
            currentIndex += 1
        } else {
            state = .finished
            sessionStore?.addSession(
                mode: .quizRush,
                score: score,
                latitude: locationService?.currentLocation?.latitude ?? 0,
                longitude: locationService?.currentLocation?.longitude ?? 0
            )
        }
    }

    func restart() {
        Task {
            await load()
        }
    }
}
