//
//  LanguageSelectionView.swift
//  OceanScript
//
//  Created by Vlad on 4/5/25.
//

import SwiftUI

struct LanguageSelectionView: View {
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var persistenceController: PersistenceController
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isLoading: Bool = false
    
    // MARK: - Body
    var body: some View {
        ZStack {
            List {
                Section(header: Text(LocalizedStringKey("INTERFACE LANGUAGE"))) {
                    ForEach(SupportedLanguage.allCases) { language in
                        Button {
                            isLoading = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                persistenceController.setLanguage(language.rawValue)
                                isLoading = false
                                dismiss()
                            }
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
                            .opacity(isLoading && persistenceController.currentLanguage != language.rawValue ? 0.7 : 1.0)
                        }
                        .buttonStyle(.plain)
                        .disabled(isLoading && persistenceController.currentLanguage != language.rawValue)
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
            
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2.0)
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
