//
//  MainTabView.swift
//  OceanScript
//
//  Created by Vlad on 26/4/25.
//

import SwiftUI

// MARK: - 
struct MainTabView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var persistenceController: PersistenceController
    
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
                }
            }
            
            Tab("Favorites", systemImage: "heart") {
                NavigationStack(path: pathBinding(for: "favorites")) {
                    FavoritesTabView()
                        .environment(\.managedObjectContext, viewContext)
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
                }
            }
            
            Tab("Search", systemImage: "magnifyingglass") {
                NavigationStack(path: pathBinding(for: "search")) {
                    SearchTabView()
                        .environment(\.managedObjectContext, viewContext)
                }
            }
            
            Tab("Settings", systemImage: "gearshape") {
                NavigationStack(path: pathBinding(for: "settings")) {
                    SettingsTabView()
                        .environment(\.managedObjectContext, viewContext)
                }
            }
        }
        .environment(\.locale, persistenceController.locale)
        .onReceive(persistenceController.$currentLanguage) { newLanguage in
            languageId = newLanguage
        }
    }
    
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
