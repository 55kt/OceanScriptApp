//
//  OceanScriptApp.swift
//  OceanScript
//
//  Created by Vlad on 25/4/25.
//

import SwiftUI
import CoreData

@main
struct OceanScriptApp: App {
    let persistenceController = PersistenceController.shared
    
    @State private var hasSelectedLanguage: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if hasSelectedLanguage {
                MainTabView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                ProgrammingLanguageSelectionView(hasSelectedLanguage: $hasSelectedLanguage)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .onAppear {
                        
                        // Checking if a programming language is selected
                        let fetchRequest: NSFetchRequest<AppLanguage> = AppLanguage.fetchRequest()
                        do {
                            let languages = try persistenceController.container.viewContext.fetch(fetchRequest)
                            if let appLanguage = languages.first, !appLanguage.programmingLanguage.isEmpty {
                                hasSelectedLanguage = true
                            }
                        } catch {
                            print("💾 Error fetching AppLanguage on app start: \(error) 💾")
                        }
                    }
            }
        }
    }
}
