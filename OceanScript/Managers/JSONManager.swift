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
            
            // Step 1: Save IDs of favorite questions
            let favoriteFetchRequest: NSFetchRequest<Question> = Question.fetchRequest()
            favoriteFetchRequest.predicate = NSPredicate(format: "isFavorite == %@", NSNumber(value: true))
            let favoriteQuestions = try context.fetch(favoriteFetchRequest)
            let favoriteQuestionIds = favoriteQuestions.compactMap { $0.id }
            print("🔍 Saved \(favoriteQuestionIds.count) favorite question IDs: \(favoriteQuestionIds)")
            
            // Step 2: Delete ALL existing categories and questions
            let entities = ["Category", "Question"]
            for entity in entities {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                do {
                    try context.execute(deleteRequest)
                } catch {
                    print("🚨 Error deleting \(entity) entities: \(error) 🚨")
                }
            }
            
            // Step 3: Load new categories and questions from JSON
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
            
            // Step 4: Save new categories and questions
            var seenCategoryIds = Set<String>()
            for category in container.categories {
                let categoryId = category.id // Убрали guard let, так как id не опциональный
                if seenCategoryIds.contains(categoryId) {
                    print("🚨 Duplicate category id \(categoryId) found 🚨")
                    continue
                }
                seenCategoryIds.insert(categoryId)
                
                context.insert(category)
                if let questions = category.questions as? Set<Question> {
                    for question in questions {
                        question.category = category
                    }
                }
            }
            
            try context.save()
            
            // Step 5: Restore favorites by matching IDs
            let allQuestionsFetchRequest: NSFetchRequest<Question> = Question.fetchRequest()
            let allQuestions = try context.fetch(allQuestionsFetchRequest)
            for question in allQuestions {
                if favoriteQuestionIds.contains(question.id ?? "") {
                    question.isFavorite = true
                }
            }
            
            try context.save()
            print("🔍 Restored \(favoriteQuestionIds.count) favorite questions")
        } catch {
            print("🚨 Error loading categories and questions: \(error) 🚨")
        }
    }
}

struct CategoriesContainer: Codable {
    let categories: [Category]
}
