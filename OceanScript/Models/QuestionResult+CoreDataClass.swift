//
//  QuestionResult+CoreDataClass.swift
//  OceanScript
//
//  Created by Vlad on 25/4/25.
//

import Foundation

import Foundation
import CoreData

@objc(QuestionResult)
public class QuestionResult: NSManagedObject, Identifiable, Codable {
    enum CodingKeys: String, CodingKey {
        case isAnsweredCorrectly
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            fatalError("💥 Failed to decode QuestionResult: Missing managed object context 💥")
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isAnsweredCorrectly = try container.decode(Bool.self, forKey: .isAnsweredCorrectly)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isAnsweredCorrectly, forKey: .isAnsweredCorrectly)
    }
}
