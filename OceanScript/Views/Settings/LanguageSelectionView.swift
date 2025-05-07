//
//  LanguageSelectionView.swift
//  OceanScript
//
//  Created by Vlad on 4/5/25.
//

import SwiftUI

// MARK: - View
struct LanguageSelectionView: View {
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var persistenceController: PersistenceController
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.locale) private var locale
    @State private var isLoading: Bool = false
    @State private var showRestartAlert: Bool = false
    @State private var selectedLanguage: SupportedLanguage?
    
    // MARK: - Body
    var body: some View {
        ZStack { // ZStack
            List { // List
                Section(header: Text(LocalizedStringKey("INTERFACE LANGUAGE"))) { // Section
                    ForEach(SupportedLanguage.allCases) { language in // ForEach
                        LanguageItemView(
                            language: language,
                            isSelected: persistenceController.currentLanguage == language.rawValue,
                            isLoading: isLoading,
                            action: {
                                selectedLanguage = language
                                showRestartAlert = true
                            }
                        )
                    } // ForEach
                } // Section
            } // List
            .navigationBarBackButtonHidden(true)
            .toolbar { // toolbar
                ToolbarItem(placement: .navigationBarLeading) { // ToolbarItem
                    Button { // Button
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .font(.title2)
                            .bold()
                    } // Button
                    .accessibilityLabel("Go back")
                } // ToolbarItem
            } // toolbar
            .listStyle(InsetGroupedListStyle())
            .navigationTitle(LocalizedStringKey("Language Selection"))
            .navigationBarTitleDisplayMode(.inline)
            .disabled(isLoading)
            .alert(isPresented: $showRestartAlert) { // alert
                Alert(
                    title: Text(LocalizedStringKey("Language Change")),
                    message: Text(LocalizedStringKey("To change the language, the app will be restarted.")),
                    primaryButton: .default(Text(LocalizedStringKey("OK"))) {
                        if let language = selectedLanguage {
                            isLoading = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                persistenceController.setLanguage(language.rawValue)
                                // Завершаем приложение для перезапуска
                                exit(0)
                            }
                        }
                    },
                    secondaryButton: .cancel(Text(LocalizedStringKey("Cancel"))) {
                        selectedLanguage = nil
                        showRestartAlert = false
                    }
                )
            } // alert
            
            if isLoading {
                VStack(spacing: 10) { // VStack
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2.0)
                        .accessibilityLabel("Loading indicator")
                    Text(LocalizedStringKey("Changing language in progress..."))
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .accessibilityLabel("Changing language in progress message")
                } // VStack
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.2))
                .ignoresSafeArea()
            } // if
        } // ZStack
        .environment(\.locale, persistenceController.locale)
        .accessibilityLabel("Language selection screen")
    } // Body
} // LanguageSelectionView

// MARK: - Preview
#Preview {
    NavigationStack { // NavigationStack
        LanguageSelectionView()
            .environmentObject(ThemeManager())
            .environmentObject(PersistenceController.preview)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    } // NavigationStack
} // Preview
