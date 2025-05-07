//
//  Tests.swift
//  OceanScript
//
//  Created by Vlad on 2/5/25.
//

import Foundation

// MARK: - Enums

/// Represents an answer option for a test question, either correct or incorrect.
enum AnswerOption: Equatable {
    // MARK: - Cases
    case correct(String)
    case incorrect(String)
    
    // MARK: - Properties
    
    /// The text content of the answer option.
    var text: String {
        switch self {
        case .correct(let text), .incorrect(let text):
            return text
        }
    }
    
    /// Indicates whether the answer option is correct.
    var isCorrect: Bool {
        switch self {
        case .correct:
            return true
        case .incorrect:
            return false
        }
    }
} // AnswerOption

/// Represents a message to display based on the test result percentage.
enum TestResultMessage: String {
    // MARK: - Cases
    case excellent = "Excellent! You're a pro! 🚀"
    case good = "Good Job! Keep it up! 👍"
    case average = "Nice effort! Try again to improve! 😊"
    case tryAgain = "Try Again! You'll get it next time! 💪"
    
    // MARK: - Static Methods
    
    /// Determines the appropriate message based on the percentage of correct answers.
    /// - Parameter percentage: The percentage of correct answers (0 to 100).
    /// - Returns: The corresponding TestResultMessage.
    static func message(forCorrectPercentage percentage: Double) -> TestResultMessage {
        percentage >= 90 ? .excellent :
        percentage >= 70 ? .good :
        percentage >= 50 ? .average :
        .tryAgain
    }
} // TestResultMessage

/// Represents navigation cases for the test flow.
enum TestNavigation: Hashable {
    // MARK: - Cases
    case test(numberOfQuestions: Int)
    case result(testTime: TimeInterval, totalQuestions: Int, correctAnswers: Int, incorrectAnswers: Int, testResults: [QuestionResult])
} // TestNavigation
