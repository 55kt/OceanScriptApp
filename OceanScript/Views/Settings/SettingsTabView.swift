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
    
    var body: some View {
        NavigationStack {
            Form {
                AppearanceSectionView()
                
                Section(header: Text("Language Selection")) {
                    NavigationLink {
                        LanguageSelectionView()
                            .environment(\.managedObjectContext, viewContext)
                    } label : {
                        HStack {
                            Text("Current Language")
                                .font(.headline)
                            
                            Spacer()
                            
                            Text("English")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .environment(\.locale, persistenceController.locale)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
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
