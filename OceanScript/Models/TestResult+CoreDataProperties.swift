//
//  TestResult+CoreDataProperties.swift
//  OceanScript
//
//  Created by Vlad on 25/4/25.
//

import Foundation
import CoreData

extension TestResult {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TestResult> {
        return NSFetchRequest<TestResult>(entityName: "TestResult")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: Date
    @NSManaged public var totalQuestions: Int32
    @NSManaged public var correctAnswers: Int32
    @NSManaged public var duration: String
    @NSManaged public var questionResults: NSSet?

    var answeredQuestions: [(question: Question, isCorrect: Bool)] {
        guard let questionResultsSet = questionResults else { return [] }
        let questionResultsArray = questionResultsSet.allObjects as? [QuestionResult] ?? []
        return questionResultsArray.compactMap { questionResult in
            guard let question = questionResult.question else { return nil }
            return (question: question, isCorrect: questionResult.isAnsweredCorrectly)
        }.sorted { $0.question.name < $1.question.name }
    }

    @objc(addQuestionResultsObject:)
    @NSManaged public func addToQuestionResults(_ value: QuestionResult)

    @objc(removeQuestionResultsObject:)
    @NSManaged public func removeFromQuestionResults(_ value: QuestionResult)

    @objc(addQuestionResults:)
    @NSManaged public func addToQuestionResults(_ values: NSSet)

    @objc(removeQuestionResults:)
    @NSManaged public func removeFromQuestionResults(_ values: NSSet)
}
