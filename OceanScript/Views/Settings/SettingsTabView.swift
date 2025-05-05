//
//  SettingsTabView.swift
//  OceanScript
//
//  Created by Vlad on 3/5/25.
//

import SwiftUI

struct SettingsTabView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var persistenceController: PersistenceController
    @Environment(\.managedObjectContext) private var viewContext
    
    // Helper to get the localized language name
    private var currentLanguageName: String {
        if let language = SupportedLanguage(rawValue: persistenceController.currentLanguage) {
            return language.nativeName // Use nativeName for display (e.g., "Русский", "English")
        }
        return "Unknown"
    }
    
    var body: some View {
        NavigationStack {
            Form {
                AppearanceSectionView()
                
                Section(header: Text("Language Selection")) {
                    NavigationLink {
                        LanguageSelectionView()
                            .environment(\.managedObjectContext, viewContext)
                    } label: {
                        HStack {
                            Text("Current Language")
                                .font(.headline)
                            
                            Spacer()
                            
                            // Display the current language name using SupportedLanguage
                            Text(currentLanguageName)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
        .environment(\.locale, persistenceController.locale)
    }
}

#Preview {
    NavigationStack {
        SettingsTabView()
            .environmentObject(ThemeManager())
            .environmentObject(PersistenceController.preview)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
