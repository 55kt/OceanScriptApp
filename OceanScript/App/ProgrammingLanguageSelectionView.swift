//
//  ProgrammingLanguageSelectionView.swift
//  OceanScript
//
//  Created by Vlad on 26/4/25.
//

import SwiftUI
import CoreData

// MARK: - View
struct ProgrammingLanguageSelectionView: View {
    // MARK: - Properties
    @Environment(\.managedObjectContext) private var viewContext: NSManagedObjectContext
    @Binding var hasSelectedLanguage: Bool
    @State private var isSelecting: Bool = false
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 20) {
            Text("Select Programming Language")
                .font(.title)
                .padding()
            
            PrimaryButton(
                title: "Swift", backgroundColor: .orange.opacity(0.6),
                action: { selectProgrammingLanguage("Swift") },
                isDisabled: isSelecting
            )
            
            PrimaryButton(
                title: "Python", backgroundColor: .blue.opacity(0.6),
                action: { selectProgrammingLanguage("Python") },
                isDisabled: isSelecting
            )
            
            Spacer()
        } // VStack
        .padding(.top, 50)
    } // Body
    
    // MARK: - Functions
    /// Selects a programming language and updates the app state accordingly.
    /// - Parameter language: The selected programming language
    private func selectProgrammingLanguage(_ language: String) {
        isSelecting = true
        
        // Perform CoreData operations in a background thread
        Task {
            try await viewContext.perform {
                // Update AppLanguage with the selected programming language
                let fetchRequest: NSFetchRequest<AppLanguage> = AppLanguage.fetchRequest()
                let languages = try viewContext.fetch(fetchRequest)
                
                let appLanguage: AppLanguage = languages.first ?? AppLanguage(context: viewContext)
                appLanguage.languageCode = "en" // Default language
                appLanguage.jsonFileName = "questions_\(language.lowercased())_en"
                appLanguage.programmingLanguage = language
                
                try viewContext.save()
                
                // Load data from JSON
                let persistenceController = PersistenceController.shared
                persistenceController.loadCategoriesAndQuestions(into: viewContext)
                
                // Update the context to trigger a @FetchRequest update
                viewContext.refreshAllObjects()
            }
            
            // Update UI on the main thread
            await MainActor.run {
                hasSelectedLanguage = true
                isSelecting = false
            }
        }// Task
    } // Function: selectProgrammingLanguage
} // ProgrammingLanguageSelectionView

// MARK: - Preview
#Preview {
    ProgrammingLanguageSelectionView(hasSelectedLanguage: .constant(false))
} // Preview
