//
//  PreviewPlaceholder.swift
//  OceanScript
//
//  Created by Vlad on 26/4/25.
//

import Foundation
import CoreData

struct PreviewPlaceholder {
    static func createCategory(in context: NSManagedObjectContext) -> Category {
        let category = Category(context: context)
        category.id = "1"
        category.name = "Basics"
        category.icon = "book.fill"
        return category
    }
    
    static func createQuestion(in context: NSManagedObjectContext, category: Category) -> Question {
        let question = Question(context: context)
        question.id = "1"
        question.name = "What is 2 + 2?"
        question.about = "A simple arithmetic question"
        question.icon = "questionmark.circle"
        question.isFavorite = false
        question.correctAnswer = "4"
        question.category = category
        return question
    }
    
    static func createTestResult(in context: NSManagedObjectContext, question: Question) -> TestResult {
        let testResult = TestResult(context: context)
        testResult.id = UUID()
        testResult.date = Date()
        testResult.totalQuestions = 1
        testResult.correctAnswers = 1
        testResult.duration = "00:01:00"
        
        let questionResult = QuestionResult(context: context)
        questionResult.isAnsweredCorrectly = true
        questionResult.question = question
        questionResult.testResult = testResult
        
        return testResult
    }
    
    static func createAppLanguage(in context: NSManagedObjectContext) -> AppLanguage {
        let appLanguage = AppLanguage(context: context)
        appLanguage.languageCode = "en"
        appLanguage.jsonFileName = "questions_en"
        return appLanguage
    }
    
    static func setupPreviewData(in context: NSManagedObjectContext) {
        let category = createCategory(in: context)
        let question = createQuestion(in: context, category: category)
        let _ = createTestResult(in: context, question: question)
        let _ = createAppLanguage(in: context)
        
        do {
            try context.save()
        } catch {
            print("💾 Error saving preview data: \(error) 💾")
        }
    }
}
