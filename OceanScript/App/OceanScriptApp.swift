//
//  OceanScriptApp.swift
//  OceanScript
//
//  Created by Vlad on 25/4/25.
//

import SwiftUI
import CoreData

// MARK: - App Entry Point
@main
struct OceanScriptApp: App {
    // MARK: - Properties
    private let persistenceController: PersistenceController = .shared
    @StateObject private var themeManager: ThemeManager = ThemeManager()
    @State private var hasSelectedLanguage: Bool
    
    // MARK: - Initializers
    init() {
        _hasSelectedLanguage = State(initialValue: persistenceController.hasSelectedProgrammingLanguage())
    }
    
    // MARK: - Body
    var body: some Scene {
        WindowGroup {
            Group {
                if hasSelectedLanguage {
                    MainTabView()
                } else {
                    ProgrammingLanguageSelectionView(hasSelectedLanguage: $hasSelectedLanguage)
                }
            } // Group
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .environmentObject(themeManager)
            .environmentObject(persistenceController)
            .environment(\.locale, persistenceController.locale)
            .preferredColorScheme(themeManager.themeMode.colorScheme)
        } // WindowGroup
    } // Body
} // OceanScriptApp
