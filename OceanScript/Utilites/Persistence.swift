//
//  PersistenceController.swift
//  OceanScript
//
//  Created by Vlad on 25/4/25.
//

import CoreData

class PersistenceController: ObservableObject {
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
    
    // Property for managing interface language
    @Published var currentLanguage: String
    
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
        self.currentLanguage = "en" // Temporary value
        self.currentLanguage = fetchLanguage(from: context) ?? defaultLanguage()
    }
    
    func loadCategoriesAndQuestions(into context: NSManagedObjectContext) {
        JSONManager.shared.loadCategoriesAndQuestions(into: context)
    }
    
    // MARK: - Language Management
    func setLanguage(_ language: String) {
        currentLanguage = language
        let context = container.viewContext
        updateLanguageInCoreData(language: language, context: context)
        updateAppLocale()
    }
    
    var locale: Locale {
        return Locale(identifier: currentLanguage)
    }
    
    private func fetchLanguage(from context: NSManagedObjectContext) -> String? {
        guard let appLanguage = fetchOrCreateAppLanguage(from: context, errorMessage: "fetching language") else {
            return nil
        }
        return appLanguage.languageCode
    }
    
    private func updateLanguageInCoreData(language: String, context: NSManagedObjectContext) {
        guard let appLanguage = fetchOrCreateAppLanguage(from: context, errorMessage: "updating language") else {
            return
        }
        appLanguage.languageCode = language
        appLanguage.jsonFileName = "questions_\(appLanguage.programmingLanguage.lowercased())_\(language)"
        saveContext(context: context, errorMessage: "updating language to \(language)")
    }
    
    private func defaultLanguage() -> String {
        let deviceLanguage = Locale.current.language.languageCode?.identifier ?? "en"
        let supportedLanguages = SupportedLanguage.allCases.map { $0.rawValue }
        return supportedLanguages.contains(deviceLanguage) ? deviceLanguage : "en"
    }
    
    private func updateAppLocale() {
        // Update the app's locale through Bundle
        Bundle.main.updateLocale(to: currentLanguage)
    }
    
    // MARK: - Helper Methods
    private func fetchOrCreateAppLanguage(from context: NSManagedObjectContext, errorMessage: String) -> AppLanguage? {
        let fetchRequest: NSFetchRequest<AppLanguage> = AppLanguage.fetchRequest()
        do {
            let languages = try context.fetch(fetchRequest)
            if let appLanguage = languages.first {
                return appLanguage
            } else {
                let newLanguage = AppLanguage(context: context)
                newLanguage.languageCode = "en"
                newLanguage.jsonFileName = ""
                newLanguage.programmingLanguage = ""
                try context.save()
                print("🔍 PersistenceController: Created new AppLanguage with languageCode: \(newLanguage.languageCode ?? "nil")")
                return newLanguage
            }
        } catch {
            print("❌ Error \(errorMessage): \(error)")
            return nil
        }
    }
    
    private func saveContext(context: NSManagedObjectContext, errorMessage: String) {
        do {
            try context.save()
            print("🔍 PersistenceController: \(errorMessage)")
        } catch {
            print("❌ Error \(errorMessage): \(error)")
        }
    }
}

// MARK: - Bundle Locale Extension
extension Bundle {
    func updateLocale(to language: String) {
        UserDefaults.standard.set(language, forKey: "AppLanguage")
        UserDefaults.standard.synchronize()
    }
}
