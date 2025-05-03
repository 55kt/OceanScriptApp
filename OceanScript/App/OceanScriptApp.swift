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
    
    @State private var hasSelectedLanguage: Bool
    
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
                if hasSelectedLanguage {
                    MainTabView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .environmentObject(themeManager)
                } else {
                    ProgrammingLanguageSelectionView(hasSelectedLanguage: $hasSelectedLanguage)
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .environmentObject(themeManager)
                }
            }
            .preferredColorScheme(themeManager.themeMode.colorScheme)
        }
    }
}
