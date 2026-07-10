//
//  Question.swift
//  TapFrenzy
//
//  Created by Thimanjila Udangawe on 2026-07-09.
//

import Foundation

struct TriviaResponse: Codable {
    let results: [Question]
}

struct Question: Codable, Identifiable {
    var id: String { question }

    let question: String
    let correct_answer: String
    let incorrect_answers: [String]

    var allAnswers: [String] {
        (incorrect_answers + [correct_answer]).shuffled()
    }
}
