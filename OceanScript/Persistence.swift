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
        
        // Создаём тестовую категорию с одним вопросом
        let category = Category(context: viewContext)
        category.id = "1"
        category.name = "Basics"
        category.icon = "book.fill"
        
        let question = Question(context: viewContext)
        question.id = "1"
        question.name = "What is 2 + 2?"
        question.about = "A simple arithmetic question"
        question.icon = "questionmark.circle"
        question.isFavorite = false
        question.correctAnswer = "4"
//        question.incorrectAnswers = ["3", "5", "6"]
        question.category = category
        
        // Создаём тестовый TestResult и QuestionResult
        let testResult = TestResult(context: viewContext)
        testResult.id = UUID()
        testResult.date = Date()
        testResult.totalQuestions = 1
        testResult.correctAnswers = 1
        testResult.duration = "00:01:00"
        
        let questionResult = QuestionResult(context: viewContext)
        questionResult.isAnsweredCorrectly = true
        questionResult.question = question
        questionResult.testResult = testResult
        
        // Создаём AppLanguage с языком по умолчанию
        let appLanguage = AppLanguage(context: viewContext)
        appLanguage.languageCode = "en"
        appLanguage.jsonFileName = "questions_en"
        
        do {
            try viewContext.save()
        } catch {
            print("💾 Error saving preview context: \(error) 💾")
        }
        
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
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
                // Создаём объект AppLanguage с языком по умолчанию
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
        // Пока оставим заглушку, так как JSON ещё не добавлен
        // Этот метод будет загружать данные из JSON, но сейчас он пустой
    }
}

struct CategoriesContainer: Codable {
    let categories: [Category]
}
