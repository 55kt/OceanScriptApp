//
//  PersistenceController.swift
//  OceanScript
//
//  Created by Vlad on 25/4/25.
//

import CoreData

// MARK: - Class
/// A singleton class responsible for managing Core Data persistence and app language settings.
class PersistenceController: ObservableObject {
    // MARK: - Singleton
    static let shared = PersistenceController()
    
    // MARK: - Preview
    /// A preview instance of the persistence controller with in-memory storage for testing.
    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        result.loadCategoriesAndQuestions(into: viewContext)
        do {
            try viewContext.save()
            result.logInfo("Successfully saved preview context")
        } catch {
            result.logError("Error saving preview context: \(error)")
        }
        return result
    }()
    
    // MARK: - Properties
    let container: NSPersistentContainer
    
    @Published var currentLanguage: String
    
    // MARK: - Initializers
    /// Initializes the persistence controller.
    /// - Parameter inMemory: If true, uses an in-memory store; otherwise, uses a persistent store.
    init(inMemory: Bool = false) {
        StringArrayTransformer.register()
        
        container = NSPersistentContainer(name: "OceanScript")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        let context = container.viewContext
        currentLanguage = "en"
        currentLanguage = fetchLanguage(from: context) ?? defaultLanguage()
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                self.logError("Error loading persistent stores: \(error), \(error.userInfo)")
            } else {
                self.logInfo("Persistent stores loaded successfully")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // MARK: - Methods
    
    /// Loads categories and questions into the specified Core Data context.
    /// - Parameter context: The Core Data managed object context to populate with data.
    func loadCategoriesAndQuestions(into context: NSManagedObjectContext) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .dataLoadingStarted, object: nil)
        }
        logInfo("Starting to load categories and questions")
        
        JSONManager.shared.loadCategoriesAndQuestions(into: context)
        
        logInfo("Finished loading categories and questions")
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .dataLoadingFinished, object: nil)
        }
    }
    
    /// Sets the app's language, updates Core Data, and reloads categories and questions.
    /// - Parameter language: The language code to set.
    func setLanguage(_ language: String) {
        currentLanguage = language
        let context = container.viewContext
        updateLanguageInCoreData(language: language, context: context)
        updateAppLocale()
        
        loadCategoriesAndQuestions(into: context)
        DispatchQueue.main.async {
            context.refreshAllObjects()
        }
    }
    
    /// The current locale based on the selected language.
    var locale: Locale {
        Locale(identifier: currentLanguage)
    }
    
    /// Checks if a programming language has been selected.
    /// - Returns: True if a programming language is selected, false otherwise.
    func hasSelectedProgrammingLanguage() -> Bool {
        let context = container.viewContext
        guard let appLanguage = fetchOrCreateAppLanguage(from: context, errorMessage: "checking programming language selection") else {
            return false
        }
        return !appLanguage.programmingLanguage.isEmpty
    }
    
    // MARK: - Private Methods
    
    /// Fetches the current language from Core Data.
    /// - Parameter context: The Core Data managed object context.
    /// - Returns: The current language code, or nil if not found.
    private func fetchLanguage(from context: NSManagedObjectContext) -> String? {
        guard let appLanguage = fetchOrCreateAppLanguage(from: context, errorMessage: "fetching language") else {
            return nil
        }
        return appLanguage.languageCode
    }
    
    /// Updates the app language in Core Data.
    /// - Parameters:
    ///   - language: The language code to set.
    ///   - context: The Core Data managed object context.
    private func updateLanguageInCoreData(language: String, context: NSManagedObjectContext) {
        guard let appLanguage = fetchOrCreateAppLanguage(from: context, errorMessage: "updating language") else {
            return
        }
        appLanguage.languageCode = language
        appLanguage.jsonFileName = "questions_\(appLanguage.programmingLanguage.lowercased())_\(language)"
        saveContext(context: context, errorMessage: "updating language to \(language)")
    }
    
    /// Returns the default language based on the device locale or falls back to "en".
    /// - Returns: The default language code.
    private func defaultLanguage() -> String {
        let deviceLanguage = Locale.current.language.languageCode?.identifier ?? "en"
        let supportedLanguages = SupportedLanguage.allCases.map { $0.rawValue }
        return supportedLanguages.contains(deviceLanguage) ? deviceLanguage : "en"
    }
    
    /// Updates the app's locale in UserDefaults.
    private func updateAppLocale() {
        Bundle.main.updateLocale(to: currentLanguage)
    }
    
    /// Fetches or creates an AppLanguage entity in Core Data.
    /// - Parameters:
    ///   - context: The Core Data managed object context.
    ///   - errorMessage: The error message to log if an error occurs.
    /// - Returns: The fetched or created AppLanguage entity, or nil if an error occurs.
    private func fetchOrCreateAppLanguage(from context: NSManagedObjectContext, errorMessage: String) -> AppLanguage? {
        let fetchRequest: NSFetchRequest<AppLanguage> = AppLanguage.fetchRequest()
        do {
            let languages = try context.fetch(fetchRequest)
            if let appLanguage = languages.first {
                return appLanguage
            } else {
                let newLanguage = AppLanguage(context: context)
                let initialLanguage = defaultLanguage()
                newLanguage.languageCode = initialLanguage
                newLanguage.jsonFileName = ""
                newLanguage.programmingLanguage = ""
                try context.save()
                logInfo("Created new AppLanguage with languageCode: \(newLanguage.languageCode)")
                return newLanguage
            }
        } catch {
            logError("Error \(errorMessage): \(error)")
            return nil
        }
    }
    
    /// Saves the specified Core Data context.
    /// - Parameters:
    ///   - context: The Core Data managed object context to save.
    ///   - errorMessage: The error message to log if an error occurs.
    private func saveContext(context: NSManagedObjectContext, errorMessage: String) {
        do {
            try context.save()
            logInfo(errorMessage)
        } catch {
            logError("Error \(errorMessage): \(error)")
        }
    }
    
    // MARK: - Logging Helpers
    
    /// Logs an informational message.
    /// - Parameter message: The message to log.
    private func logInfo(_ message: String) {
        #if DEBUG
        print("ℹ️ PersistenceController: \(message)")
        #endif
    }
    
    /// Logs an error message.
    /// - Parameter message: The error message to log.
    private func logError(_ message: String) {
        #if DEBUG
        print("❌ PersistenceController: \(message)")
        #endif
    }
} // PersistenceController

// MARK: - Extensions

extension Bundle {
    /// Updates the app's locale in UserDefaults.
    /// - Parameter language: The language code to set.
    func updateLocale(to language: String) {
        UserDefaults.standard.set(language, forKey: "AppLanguage")
        UserDefaults.standard.synchronize()
    }
}

extension Notification.Name {
    static let dataLoadingStarted = Notification.Name("DataLoadingStarted")
    static let dataLoadingFinished = Notification.Name("DataLoadingFinished")
}
