//
//  Persistence.swift
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
        
        PreviewPlaceholder.setupPreviewData(in: viewContext)
        
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        // Register a custom Value Transformer
        ArrayValueTransformer.register()
        
        container = NSPersistentContainer(name: "OceanScript")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("💾 Error loading persistent stores: \(error), \(error.userInfo) 💾")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        let context = container.viewContext
        setupInitialLanguage(into: context)
        loadCategoriesAndQuestions(into: context)
    }
    
    private func setupInitialLanguage(into context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<AppLanguage> = AppLanguage.fetchRequest()
        
        do {
            let languages = try context.fetch(fetchRequest)
            if languages.isEmpty {
                // Create an AppLanguage object with the default language
                let defaultLanguage = AppLanguage(context: context)
                defaultLanguage.languageCode = "en"
                defaultLanguage.jsonFileName = "questions_en"
                try context.save()
            }
        } catch {
            print("💾 Error setting up initial language: \(error) 💾")
        }
    }
    
    private func loadCategoriesAndQuestions(into context: NSManagedObjectContext) {
        // Leave the stub for now since the JSON hasn't been added yet
        // This method will load data from the JSON, but it's empty right now
    }
}

struct CategoriesContainer: Codable {
    let categories: [Category]
}
