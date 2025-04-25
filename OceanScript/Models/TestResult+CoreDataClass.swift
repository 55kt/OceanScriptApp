//
//  TestResult+CoreDataClass.swift
//  OceanScript
//
//  Created by Vlad on 25/4/25.
//

import Foundation
import CoreData

@objc(TestResult)
public class TestResult: NSManagedObject, Identifiable, Codable {
    enum CodingKeys: String, CodingKey {
        case id, date, totalQuestions, correctAnswers, duration, questionResults
    }
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        if id == nil {
            id = UUID()
        }
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            fatalError("💥 Failed to decode TestResult: Missing managed object context 💥")
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        self.date = try container.decode(Date.self, forKey: .date)
        self.totalQuestions = try container.decode(Int32.self, forKey: .totalQuestions)
        self.correctAnswers = try container.decode(Int32.self, forKey: .correctAnswers)
        self.duration = try container.decode(String.self, forKey: .duration)
        
        if let questionResultsArray = try container.decodeIfPresent([QuestionResult].self, forKey: .questionResults), !questionResultsArray.isEmpty {
            self.questionResults = NSSet(array: questionResultsArray)
        } else {
            self.questionResults = NSSet()
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(totalQuestions, forKey: .totalQuestions)
        try container.encode(correctAnswers, forKey: .correctAnswers)
        try container.encode(duration, forKey: .duration)
        try container.encode(questionResults?.allObjects as? [QuestionResult] ?? [], forKey: .questionResults)
    }
}
