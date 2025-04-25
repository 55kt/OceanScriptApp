//
//  AppLanguage+CoreDataProperties.swift
//  OceanScript
//
//  Created by Vlad on 25/4/25.
//

import Foundation
import CoreData

extension AppLanguage {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppLanguage> {
        return NSFetchRequest<AppLanguage>(entityName: "AppLanguage")
    }

    @NSManaged public var languageCode: String
    @NSManaged public var jsonFileName: String
}
