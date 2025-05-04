//
//  SettingsTabView.swift
//  OceanScript
//
//  Created by Vlad on 3/5/25.
//

import SwiftUI

struct SettingsTabView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        NavigationStack {
            Form {
                AppearanceSectionView()
                
                Section(header: Text("Language Selection")) {
                    NavigationLink {
                        LanguageSelectionView()
                    } label : {
                        HStack {
                            Text("Current Language")
                                .font(.headline)
                            
                            Spacer()
                            
                            Text("English")
                                .foregroundStyle(.secondary)
                        }
                    }
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
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
