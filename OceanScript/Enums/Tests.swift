//
//  Tests.swift
//  OceanScript
//
//  Created by Vlad on 2/5/25.
//

import Foundation

enum AnswerOption: Equatable {
    case correct(String)
    case incorrect(String)
    
    var text: String {
        switch self {
        case .correct(let text), .incorrect(let text):
            return text
        }
    }
    
    var isCorrect: Bool {
        switch self {
        case .correct:
            return true
        case .incorrect:
            return false
        }
    }
}

enum TestResultMessage: String {
    case excellent = "Excellent! You're a pro! 🚀"
    case good = "Good Job! Keep it up! 👍"
    case average = "Nice effort! Try again to improve! 😊"
    case tryAgain = "Try Again! You'll get it next time! 💪"
    
    static func message(forCorrectPercentage percentage: Double) -> TestResultMessage {
        switch percentage {
        case 90...100:
            return .excellent
        case 70..<90:
            return .good
        case 50..<70:
            return .average
        default:
            return .tryAgain
        }
    }
}

enum TestNavigation: Hashable {
    case test(numberOfQuestions: Int)
    case result(testTime: TimeInterval, totalQuestions: Int, correctAnswers: Int, incorrectAnswers: Int, testResults: [QuestionResult])
}
