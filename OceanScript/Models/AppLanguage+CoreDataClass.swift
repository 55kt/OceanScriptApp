//
//  AppLanguage+CoreDataClass.swift
//  OceanScript
//
//  Created by Vlad on 25/4/25.
//

import Foundation
import CoreData

@objc(AppLanguage)
public class AppLanguage: NSManagedObject, Identifiable, Codable {
    enum CodingKeys: String, CodingKey {
        case languageCode, jsonFileName, programmingLanguage
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            fatalError("💥 Failed to decode AppLanguage: Missing managed object context 💥")
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.languageCode = try container.decode(String.self, forKey: .languageCode)
        self.jsonFileName = try container.decode(String.self, forKey: .jsonFileName)
        self.programmingLanguage = try container.decodeIfPresent(String.self, forKey: .programmingLanguage) ?? ""
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(languageCode, forKey: .languageCode)
        try container.encode(jsonFileName, forKey: .jsonFileName)
        try container.encode(programmingLanguage, forKey: .programmingLanguage)
    }
}
