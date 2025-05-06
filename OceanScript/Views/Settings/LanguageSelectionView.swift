//
//  LanguageSelectionView.swift
//  OceanScript
//
//  Created by Vlad on 4/5/25.
//

import SwiftUI

struct LanguageSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var persistenceController: PersistenceController
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.locale) private var locale
    @State private var isLoading: Bool = false
    @State private var showRestartAlert: Bool = false
    @State private var selectedLanguage: SupportedLanguage? // Для хранения выбранного языка
    
    var body: some View {
        ZStack {
            List {
                Section(header: Text(LocalizedStringKey("INTERFACE LANGUAGE"))) {
                    ForEach(SupportedLanguage.allCases) { language in
                        Button {
                            selectedLanguage = language
                            showRestartAlert = true
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(language.englishName)
                                        .font(.headline)
                                    Text(language.nativeName)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                if persistenceController.currentLanguage == language.rawValue {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.accentColor)
                                }
                            }
                            .padding(.vertical, 6)
                            .opacity(isLoading || persistenceController.currentLanguage == language.rawValue ? 0.7 : 1.0)
                        }
                        .buttonStyle(.plain)
                        .disabled(isLoading || persistenceController.currentLanguage == language.rawValue)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .font(.title2)
                            .bold()
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle(LocalizedStringKey("Language Selection"))
            .navigationBarTitleDisplayMode(.inline)
            .disabled(isLoading)
            .alert(isPresented: $showRestartAlert) {
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
            }
            
            if isLoading {
                VStack(spacing: 10) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2.0)
                    Text(LocalizedStringKey("Changing language in progress..."))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.2))
                .ignoresSafeArea()
            }
        }
        .environment(\.locale, persistenceController.locale)
    }
}

#Preview {
    NavigationStack {
        LanguageSelectionView()
            .environmentObject(ThemeManager())
            .environmentObject(PersistenceController.preview)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
