//
//  ProgrammingLanguageSelectionView.swift
//  OceanScript
//
//  Created by Vlad on 26/4/25.
//

import SwiftUI
import CoreData

struct ProgrammingLanguageSelectionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var hasSelectedLanguage: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Select Programming Language")
                .font(.title)
                .padding()
            
            Button(action: {
                selectProgrammingLanguage("Swift")
            }) {
                Text("Swift")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Button(action: {
                selectProgrammingLanguage("Python")
            }) {
                Text("Python")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top, 50)
    }
    
    private func selectProgrammingLanguage(_ language: String) {
        
        // Update AppLanguage with the selected programming language
        let fetchRequest: NSFetchRequest<AppLanguage> = AppLanguage.fetchRequest()
        do {
            let languages = try viewContext.fetch(fetchRequest)
            if let appLanguage = languages.first {
                appLanguage.languageCode = "en" // default language
                appLanguage.jsonFileName = "questions_\(language.lowercased())_en"
                appLanguage.programmingLanguage = language
            } else {
                let newLanguage = AppLanguage(context: viewContext)
                newLanguage.languageCode = "en"
                newLanguage.jsonFileName = "questions_\(language.lowercased())_en"
                newLanguage.programmingLanguage = language
            }
            try viewContext.save()
            
            // Loading data from JSON
            let persistenceController = PersistenceController.shared
            persistenceController.loadCategoriesAndQuestions(into: viewContext)
            
            // Update the context to trigger a @FetchRequest update
            viewContext.refreshAllObjects()
            
            // Switch to MainTabView
            hasSelectedLanguage = true
        } catch {
            print("💾 Error saving AppLanguage: \(error) 💾")
        }
    }
}

#Preview {
    ProgrammingLanguageSelectionView(hasSelectedLanguage: .constant(false))
}
