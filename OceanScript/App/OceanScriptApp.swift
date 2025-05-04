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
        self._hasSelectedLanguage = State(initialValue: persistenceController.hasSelectedProgrammingLanguage())
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if hasSelectedLanguage {
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
}
