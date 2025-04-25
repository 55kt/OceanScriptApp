//
//  QuestionResult+CoreDataProperties.swift
//  OceanScript
//
//  Created by Vlad on 25/4/25.
//

import Foundation
import CoreData

extension QuestionResult {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuestionResult> {
        return NSFetchRequest<QuestionResult>(entityName: "QuestionResult")
    }

    @NSManaged public var isAnsweredCorrectly: Bool
    @NSManaged public var question: Question?
    @NSManaged public var testResult: TestResult?
}
