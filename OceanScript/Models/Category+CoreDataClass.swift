//
//  Category+CoreDataClass.swift
//  OceanScript
//
//  Created by Vlad on 25/4/25.
//

import Foundation
import CoreData

@objc(Category)
public class Category: NSManagedObject, Identifiable, Codable {
    enum CodingKeys: String, CodingKey {
        case id, name, icon, questions
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            fatalError("💥 Failed to decode Category: Missing managed object context 💥")
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.icon = try container.decode(String.self, forKey: .icon)
        
        if let questionsArray = try container.decodeIfPresent([Question].self, forKey: .questions), !questionsArray.isEmpty {
            self.questions = NSSet(array: questionsArray)
        } else {
            self.questions = NSSet()
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(icon, forKey: .icon)
        try container.encode(questions?.allObjects as? [Question] ?? [], forKey: .questions)
    }
}
