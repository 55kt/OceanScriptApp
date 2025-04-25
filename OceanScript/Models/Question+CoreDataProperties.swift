//
//  Question+CoreDataProperties.swift
//  OceanScript
//
//  Created by Vlad on 25/4/25.
//

import Foundation
import CoreData

extension Question {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Question> {
        return NSFetchRequest<Question>(entityName: "Question")
    }

    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var about: String
    @NSManaged public var icon: String
    @NSManaged public var isFavorite: Bool
    @NSManaged public var correctAnswer: String
    @NSManaged public var incorrectAnswersRaw: NSArray?
    @NSManaged public var category: Category?
    @NSManaged public var questionResults: NSSet?

    var incorrectAnswers: [String]? {
        get { return incorrectAnswersRaw as? [String] }
        set { incorrectAnswersRaw = newValue as NSArray? }
    }

    var isAnswered: Bool {
        return questionResults?.count ?? 0 > 0
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
