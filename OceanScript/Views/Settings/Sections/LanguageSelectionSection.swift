//
//  LanguageSelectionSection.swift
//  OceanScript
//
//  Created by Vlad on 8/5/25.
//

import SwiftUI

// MARK: - View
/// A view displaying the language selection section in settings.
struct LanguageSelectionSection: View {
    // MARK: - Properties
    @Environment(\.managedObjectContext) private var viewContext
    let currentLanguageName: String
    
    // MARK: - Body
    var body: some View {
        Section(header: Text(LocalizedStringKey("Language Selection"))) {
            NavigationLink { // NavigationLink
                LanguageSelectionView()
                    .environment(\.managedObjectContext, viewContext)
            } label: {
                HStack {
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
    } // Body
} // LanguageSelectionSection

// MARK: - Preview
#Preview {
    LanguageSelectionSection(currentLanguageName: "English")
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
