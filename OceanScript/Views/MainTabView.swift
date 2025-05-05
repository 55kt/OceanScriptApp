//
//  MainTabView.swift
//  OceanScript
//
//  Created by Vlad on 26/4/25.
//

import SwiftUI

struct MainTabView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var persistenceController: PersistenceController
    
    // Dictionary to store NavigationPath for each tab
    @State private var tabPaths: [String: NavigationPath] = [
        "home": NavigationPath(),
        "favorites": NavigationPath(),
        "test": NavigationPath(),
        "search": NavigationPath(),
        "settings": NavigationPath()
    ]
    
    @State private var languageId: String = PersistenceController.shared.currentLanguage
    
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                NavigationStack(path: pathBinding(for: "home")) {
                    HomeTabView()
                        .environment(\.managedObjectContext, viewContext)
                        .id(languageId)
                }
            }
            
            Tab("Favorites", systemImage: "heart") {
                NavigationStack(path: pathBinding(for: "favorites")) {
                    FavoritesTabView()
                        .environment(\.managedObjectContext, viewContext)
                        .id(languageId)
                }
            }
            
            Tab("Test", systemImage: "book") {
                NavigationStack(path: pathBinding(for: "test")) {
                    TestTabView(testPath: pathBinding(for: "test"))
                        .environment(\.managedObjectContext, viewContext)
                        .navigationDestination(for: TestNavigation.self) { destination in
                            switch destination {
                            case .test(let numberOfQuestions):
                                CurrentTestView(numberOfQuestions: numberOfQuestions, testPath: pathBinding(for: "test"))
                                    .environment(\.managedObjectContext, viewContext)
                            case .result(let testTime, let totalQuestions, let correctAnswers, let incorrectAnswers, let testResults):
                                TestResultView(
                                    testTime: testTime,
                                    totalQuestions: totalQuestions,
                                    correctAnswers: correctAnswers,
                                    incorrectAnswers: incorrectAnswers,
                                    testResults: testResults,
                                    testPath: pathBinding(for: "test")
                                )
                            }
                        }
                        .id(languageId)
                }
            }
            
            Tab("Search", systemImage: "magnifyingglass") {
                NavigationStack(path: pathBinding(for: "search")) {
                    SearchTabView()
                        .environment(\.managedObjectContext, viewContext)
                        .id(languageId)
                }
            }
            
            Tab("Settings", systemImage: "gearshape") {
                NavigationStack(path: pathBinding(for: "settings")) {
                    SettingsTabView()
                        .environment(\.managedObjectContext, viewContext)
                        .id(languageId)
                }
            }
        }
        .environment(\.locale, persistenceController.locale)
        .onReceive(persistenceController.$currentLanguage) { newLanguage in
            languageId = newLanguage
        }
    }
    
    // Helper function to create a Binding<NavigationPath> for a given tab key
    private func pathBinding(for key: String) -> Binding<NavigationPath> {
        Binding<NavigationPath>(
            get: {
                tabPaths[key] ?? NavigationPath()
            },
            set: { newValue in
                tabPaths[key] = newValue
            }
        )
    }
}

#Preview {
    NavigationStack {
        MainTabView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(ThemeManager())
            .environmentObject(PersistenceController.preview)
    }
}
