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
    
    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String = ""
    
    private let supportMailManager = SupportMailManager()
    private let supportEmail = "support@oceanscript.com" // Replace with actual support email
    
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
                
                Section { // Section
                    Button(action: {
                        supportMailManager.sendSupportEmail(
                            message: "Please describe your issue or feedback here.",
                            recipient: supportEmail
                        ) { result in
                            switch result {
                            case .success:
                                break // Email sent successfully
                            case .failure(let error):
                                // Show alert only for specific errors, not for cancellation
                                if (error as? SupportMailError) != .userSavedDraft {
                                    errorMessage = error.localizedDescription
                                    showErrorAlert = true
                                }
                            }
                        }
                    }) {
                        HStack { // HStack
                            Spacer()
                            Text(LocalizedStringKey("OceanScript Support"))
                                .foregroundStyle(.blue)
                                .font(.footnote)
                            Spacer()
                        } // HStack
                    }
                    .accessibilityLabel("OceanScript support button")
                    .accessibilityHint("Tap to contact support via email")
                } // Section
            } // Form
            .navigationTitle(Text(LocalizedStringKey("Settings")))
            .navigationBarTitleDisplayMode(.inline)
            .accessibilityLabel("Settings screen")
            .alert(isPresented: $showErrorAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
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
