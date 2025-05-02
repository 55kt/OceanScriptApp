//
//  TestNavigation.swift
//  OceanScript
//
//  Created by Vlad on 2/5/25.
//

import Foundation

enum TestNavigation: Hashable {
    case test(numberOfQuestions: Int)
    case result(testTime: TimeInterval, totalQuestions: Int, correctAnswers: Int, incorrectAnswers: Int, testResults: [QuestionResult])
}
