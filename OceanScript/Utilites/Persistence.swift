//
//  PersistenceController.swift
//  OceanScript
//
//  Created by Vlad on 25/4/25.
//

import CoreData

class PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        result.loadCategoriesAndQuestions(into: viewContext)
        do {
            try viewContext.save()
        } catch {
            print("❌ Error saving preview context: \(error)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        // Register a custom String Array Transformer for incorrectAnswers
        StringArrayTransformer.register()
        
        container = NSPersistentContainer(name: "OceanScript")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("💾 Error loading persistent stores: \(error), \(error.userInfo) 💾")
            } else {
                print("🔍 Persistent stores loaded successfully")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        let context = container.viewContext
        setupInitialLanguage(into: context)
    }
    
    private func setupInitialLanguage(into context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<AppLanguage> = AppLanguage.fetchRequest()
        
        do {
            let languages = try context.fetch(fetchRequest)
            if languages.isEmpty {
                // Create an AppLanguage object with the default language
                let defaultLanguage = AppLanguage(context: context)
                defaultLanguage.languageCode = "en"
                defaultLanguage.jsonFileName = ""
                defaultLanguage.programmingLanguage = ""
                try context.save()
                print("🔍 Initial AppLanguage setup completed")
            }
        } catch {
            print("💾 Error setting up initial language: \(error) 💾")
        }
    }
    
    func loadCategoriesAndQuestions(into context: NSManagedObjectContext) {
        JSONManager.shared.loadCategoriesAndQuestions(into: context)
    }
}
