//
//  Question+CoreDataClass.swift
//  OceanScript
//
//  Created by Vlad on 25/4/25.
//

import Foundation
import CoreData

@objc(Question)
public class Question: NSManagedObject, Identifiable, Codable {
    enum CodingKeys: String, CodingKey {
        case id, name, about, icon, isFavorite, correctAnswer, incorrectAnswers
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            fatalError("💥 Failed to decode Question: Missing managed object context 💥")
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.about = try container.decode(String.self, forKey: .about)
        self.icon = try container.decode(String.self, forKey: .icon)
        self.isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
        self.correctAnswer = try container.decode(String.self, forKey: .correctAnswer)
        self.incorrectAnswers = try container.decodeIfPresent([String].self, forKey: .incorrectAnswers)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(about, forKey: .about)
        try container.encode(icon, forKey: .icon)
        try container.encode(isFavorite, forKey: .isFavorite)
        try container.encode(correctAnswer, forKey: .correctAnswer)
        try container.encodeIfPresent(incorrectAnswers, forKey: .incorrectAnswers)
    }
}
