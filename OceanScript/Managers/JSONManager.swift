//
//  JSONManager.swift
//  OceanScript
//
//  Created by Vlad on 26/4/25.
//

import Foundation
import CoreData

class JSONManager {
    static let shared = JSONManager()
    
    private init() {}
    
    func loadCategoriesAndQuestions(into context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<AppLanguage> = AppLanguage.fetchRequest()
        
        do {
            guard let appLanguage = try context.fetch(fetchRequest).first else {
                print("🚨 No AppLanguage found 🚨")
                return
            }
            
            let jsonFileName = appLanguage.jsonFileName
            guard let url = Bundle.main.url(forResource: jsonFileName, withExtension: "json") else {
                print("🚨 Failed to locate \(jsonFileName).json in bundle 🚨")
                return
            }
            
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.userInfo[.managedObjectContext] = context
            let container = try decoder.decode(CategoriesContainer.self, from: data)
            
            print("Loaded \(container.categories.count) categories")
            for category in container.categories {
                if let questions = category.questions as? Set<Question> {
                    print("Category \(category.name) has \(questions.count) questions")
                }
            }
            
            // Deleting existing categories and questions
            let categoryFetchRequest: NSFetchRequest<NSFetchRequestResult> = Category.fetchRequest()
            let categoryDeleteRequest = NSBatchDeleteRequest(fetchRequest: categoryFetchRequest)
            try context.execute(categoryDeleteRequest)
            
            let questionFetchRequest: NSFetchRequest<NSFetchRequestResult> = Question.fetchRequest()
            let questionDeleteRequest = NSBatchDeleteRequest(fetchRequest: questionFetchRequest)
            try context.execute(questionDeleteRequest)
            
            // Saving new categories and questions
            for category in container.categories {
                context.insert(category)
                if let questions = category.questions as? Set<Question> {
                    for question in questions {
                        question.category = category
                    }
                }
            }
            
            try context.save()
        } catch {
            print("🚨 Error loading categories and questions: \(error) 🚨")
        }
    }
}

struct CategoriesContainer: Codable {
    let categories: [Category]
}
