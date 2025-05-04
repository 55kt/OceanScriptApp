//
//  OceanScriptApp.swift
//  OceanScript
//
//  Created by Vlad on 25/4/25.
//

import SwiftUI
import CoreData

@main
struct OceanScriptApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var themeManager = ThemeManager()
    
    @State private var hasSelectedLanguage: Bool = false
    @State private var isCheckingLanguage: Bool = true
    
    init() {
        let context = persistenceController.container.viewContext
        let fetchRequest: NSFetchRequest<AppLanguage> = AppLanguage.fetchRequest()
        var hasLanguage = false
        
        do {
            let languages = try context.fetch(fetchRequest)
            if let appLanguage = languages.first, !appLanguage.programmingLanguage.isEmpty {
                hasLanguage = true
            }
        } catch {
            print("💾 Error fetching AppLanguage on app start: \(error) 💾")
        }
        
        self._hasSelectedLanguage = State(initialValue: hasLanguage)
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isCheckingLanguage {
                    ProgressView()
                        .onAppear {
                            checkLanguageSelection()
                        }
                } else if hasSelectedLanguage {
                    MainTabView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .environmentObject(themeManager)
                        .environmentObject(persistenceController)
                        .environment(\.locale, persistenceController.locale)
                } else {
                    ProgrammingLanguageSelectionView(hasSelectedLanguage: $hasSelectedLanguage)
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .environmentObject(themeManager)
                        .environmentObject(persistenceController)
                        .environment(\.locale, persistenceController.locale)
                }
            }
            .preferredColorScheme(themeManager.themeMode.colorScheme)
        }
    }
    
    private func checkLanguageSelection() {
        let context = persistenceController.container.viewContext
        let fetchRequest: NSFetchRequest<AppLanguage> = AppLanguage.fetchRequest()
        do {
            let languages = try context.fetch(fetchRequest)
            if let appLanguage = languages.first {
                let programmingLanguage = appLanguage.programmingLanguage
                print("🔍 AppLanguage at launch: languageCode=\(appLanguage.languageCode ?? "nil"), programmingLanguage=\(programmingLanguage ?? "nil")")
                hasSelectedLanguage = !programmingLanguage.isEmpty
            } else {
                print("🔍 No AppLanguage record found at launch")
                hasSelectedLanguage = false
            }
        } catch {
            print("💾 Error fetching AppLanguage on app start: \(error) 💾")
            hasSelectedLanguage = false
        }
        isCheckingLanguage = false
    }
}
