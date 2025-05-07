//
//  JSONManager.swift
//  OceanScript
//
//  Created by Vlad on 26/4/25.
//

import Foundation
import CoreData

// MARK: - Class
/// A singleton class responsible for loading categories and questions from JSON into Core Data.
class JSONManager {
    // MARK: - Singleton
    static let shared = JSONManager()
    
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Methods
    
    /// Loads categories and questions from a JSON file into the specified Core Data context.
    /// - Parameter context: The Core Data managed object context to populate with data.
    func loadCategoriesAndQuestions(into context: NSManagedObjectContext) {
        logInfo("Starting to load categories and questions")
        
        // Step 1: Fetch the current app language and JSON file
        let fetchRequest: NSFetchRequest<AppLanguage> = AppLanguage.fetchRequest()
        guard let appLanguage = try? context.fetch(fetchRequest).first else {
            logError("No AppLanguage found")
            return
        }
        logInfo("Fetched AppLanguage with jsonFileName: \(appLanguage.jsonFileName)")
        
        let jsonFileName = appLanguage.jsonFileName
        guard let url = Bundle.main.url(forResource: jsonFileName, withExtension: "json") else {
            logError("Failed to locate \(jsonFileName).json in bundle")
            return
        }
        logInfo("Located JSON file: \(jsonFileName).json")
        
        do {
            // Step 2: Save IDs of favorite questions
            let favoriteFetchRequest: NSFetchRequest<Question> = Question.fetchRequest()
            favoriteFetchRequest.predicate = NSPredicate(format: "isFavorite == %@", NSNumber(value: true))
            let favoriteQuestions = try context.fetch(favoriteFetchRequest)
            let favoriteQuestionIds = favoriteQuestions.compactMap { $0.id }
            logInfo("Saved \(favoriteQuestionIds.count) favorite question IDs: \(favoriteQuestionIds)")
            
            // Step 3: Delete all existing categories and questions
            let entities = ["Category", "Question"]
            for entity in entities {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                do {
                    try context.execute(deleteRequest)
                    logInfo("Deleted all \(entity) entities")
                } catch {
                    logError("Failed to delete \(entity) entities: \(error)")
                }
            }
            
            // Step 4: Load new categories and questions from JSON
            let data = try Data(contentsOf: url)
            logInfo("Loaded JSON data with size: \(data.count) bytes")
            
            let decoder = JSONDecoder()
            decoder.userInfo[.managedObjectContext] = context
            let container = try decoder.decode(CategoriesContainer.self, from: data)
            
            logInfo("Loaded \(container.categories.count) categories")
            for category in container.categories {
                if let questions = category.questions as? Set<Question> {
                    logInfo("Category \(category.name) has \(questions.count) questions")
                }
            }
            
            // Step 5: Save new categories and questions
            var seenCategoryIds = Set<String>()
            for category in container.categories {
                let categoryId = category.id
                if seenCategoryIds.contains(categoryId) {
                    logError("Duplicate category id \(categoryId) found")
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
            
            // Save categories and questions synchronously
            saveContext(context)
            
            // Step 6: Restore favorites by matching IDs
            let allQuestionsFetchRequest: NSFetchRequest<Question> = Question.fetchRequest()
            let allQuestions = try context.fetch(allQuestionsFetchRequest)
            logInfo("Fetched \(allQuestions.count) questions for favorite restoration")
            
            for question in allQuestions {
                // Note: question.id is non-optional (String), so direct access is safe
                if favoriteQuestionIds.contains(question.id) {
                    question.isFavorite = true
                }
            }
            
            // Save restored favorites synchronously
            saveContext(context)
            logInfo("Restored \(favoriteQuestionIds.count) favorite questions")
        } catch {
            logError("Error loading categories and questions: \(error)")
        }
        
        logInfo("Finished loading categories and questions")
    }
    
    // MARK: - Private Methods
    
    /// Saves the specified Core Data context.
    /// - Parameter context: The Core Data managed object context to save.
    private func saveContext(_ context: NSManagedObjectContext) {
        do {
            try context.save()
            logInfo("Successfully saved context")
        } catch {
            logError("Failed to save context: \(error)")
        }
    }
    
    // MARK: - Logging Helpers
    
    /// Logs an informational message.
    /// - Parameter message: The message to log.
    private func logInfo(_ message: String) {
        #if DEBUG
        print("ℹ️ JSONManager: \(message)")
        #endif
    }
    
    /// Logs an error message.
    /// - Parameter message: The error message to log.
    private func logError(_ message: String) {
        #if DEBUG
        print("❌ JSONManager: \(message)")
        #endif
    }
} // JSONManager

// MARK: - Structs

/// A container for decoding categories from JSON.
struct CategoriesContainer: Codable {
    let categories: [Category]
} // CategoriesContainer
