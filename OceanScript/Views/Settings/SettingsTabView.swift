//
//  SettingsTabView.swift
//  OceanScript
//
//  Created by Vlad on 3/5/25.
//

import SwiftUI

// MARK: - View
struct SettingsTabView: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var persistenceController: PersistenceController
    @Environment(\.managedObjectContext) private var viewContext
    
    // MARK: - Private Properties
    // Helper to get the localized language name
    private var currentLanguageName: String {
        SupportedLanguage(rawValue: persistenceController.currentLanguage)?.nativeName ?? "Unknown"
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack { // NavigationStack
            Form { // Form
                AppearanceSectionView()
                
                Section(header: Text(LocalizedStringKey("Language Selection"))) { // Section
                    NavigationLink { // NavigationLink
                        LanguageSelectionView()
                            .environment(\.managedObjectContext, viewContext)
                    } label: {
                        HStack { // HStack
                            Text(LocalizedStringKey("Current Language"))
                                .font(.headline)
                                .accessibilityLabel("Current language label")
                            
                            Spacer()
                            
                            // Display the current language name using SupportedLanguage
                            Text(currentLanguageName)
                                .foregroundStyle(.secondary)
                                .accessibilityLabel("Current language: \(currentLanguageName)")
                        } // HStack
                    } // NavigationLink
                    .accessibilityHint("Tap to change the language")
                    .accessibilityValue(currentLanguageName)
                } // Section
            } // Form
            .navigationTitle(Text(LocalizedStringKey("Settings")))
            .navigationBarTitleDisplayMode(.inline)
            .accessibilityLabel("Settings screen")
        } // NavigationStack
        .environment(\.locale, persistenceController.locale)
    } // Body
} // SettingsTabView

// MARK: - Preview
#Preview {
    NavigationStack { // NavigationStack
        SettingsTabView()
            .environmentObject(ThemeManager())
            .environmentObject(PersistenceController.preview)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    } // NavigationStack
} // Preview
