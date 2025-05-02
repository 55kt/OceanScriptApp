//
//  MainTabView.swift
//  OceanScript
//
//  Created by Vlad on 26/4/25.
//

import SwiftUI

struct MainTabView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var testPath = NavigationPath() // Путь навигации для вкладки Test
    
    var body: some View {
        TabView {
            // Вкладка Home
            Tab("Home", systemImage: "house") {
                NavigationStack {
                    HomeTabView()
                        .environment(\.managedObjectContext, viewContext)
                }
            }
            
            // Вкладка Favorites
            Tab("Favorites", systemImage: "heart") {
                NavigationStack {
                    FavoritesTabView()
                        .environment(\.managedObjectContext, viewContext)
                }
            }
            
            // Вкладка Test
            Tab("Test", systemImage: "book") {
                NavigationStack(path: $testPath) {
                    TestTabView(testPath: $testPath)
                        .environment(\.managedObjectContext, viewContext)
                        .navigationDestination(for: TestNavigation.self) { destination in
                            switch destination {
                            case .test(let numberOfQuestions):
                                CurrentTestView(numberOfQuestions: numberOfQuestions, testPath: $testPath)
                                    .environment(\.managedObjectContext, viewContext)
                            case .result(let testTime, let totalQuestions, let correctAnswers, let incorrectAnswers, let testResults):
                                TestResultView(
                                    testTime: testTime,
                                    totalQuestions: totalQuestions,
                                    correctAnswers: correctAnswers,
                                    incorrectAnswers: incorrectAnswers,
                                    testResults: testResults,
                                    testPath: $testPath
                                )
                            }
                        }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MainTabView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
