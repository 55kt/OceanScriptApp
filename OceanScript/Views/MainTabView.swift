//
//  MainTabView.swift
//  OceanScript
//
//  Created by Vlad on 26/4/25.
//

import SwiftUI
import CoreData

// MARK: - View
struct MainTabView: View {
    // MARK: - Properties
    @Environment(\.managedObjectContext) private var viewContext: NSManagedObjectContext
    @EnvironmentObject private var persistenceController: PersistenceController
    @EnvironmentObject private var subscriptionManager: SubscriptionManager
    
    @State private var tabPaths: [String: NavigationPath] = [
        "home": NavigationPath(),
        "favorites": NavigationPath(),
        "test": NavigationPath(),
        "search": NavigationPath(),
        "settings": NavigationPath()
    ]
    
    @State private var showSubscriptionPrompt: Bool = false
    
    // MARK: - Body
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                NavigationStack(path: pathBinding(for: "home")) {
                    HomeTabView()
                } // NavigationStack
            } // Tab
            
            Tab("Favorites", systemImage: "heart") {
                NavigationStack(path: pathBinding(for: "favorites")) {
                    FavoritesTabView()
                } // NavigationStack
            } // Tab
            
            Tab("Test", systemImage: "book") {
                NavigationStack(path: pathBinding(for: "test")) {
                    TestTabView(testPath: pathBinding(for: "test"))
                        .navigationDestination(for: TestNavigation.self) { destination in
                            switch destination {
                            case .test(let numberOfQuestions):
                                CurrentTestView(
                                    numberOfQuestions: numberOfQuestions,
                                    testPath: pathBinding(for: "test")
                                ) // CurrentTestView
                            case .result(let testTime, let totalQuestions, let correctAnswers, let incorrectAnswers, let testResults):
                                TestResultView(
                                    testTime: testTime,
                                    totalQuestions: totalQuestions,
                                    correctAnswers: correctAnswers,
                                    incorrectAnswers: incorrectAnswers,
                                    testResults: testResults,
                                    testPath: pathBinding(for: "test")
                                ) // TestResultView
                            }
                        } // navigationDestination
                } // NavigationStack
            } // Tab
            
            Tab("Search", systemImage: "magnifyingglass") {
                NavigationStack(path: pathBinding(for: "search")) {
                    SearchTabView()
                } // NavigationStack
            } // Tab
            
            Tab("Settings", systemImage: "gearshape") {
                NavigationStack(path: pathBinding(for: "settings")) {
                    SettingsTabView()
                } // NavigationStack
            } // Tab
        } // TabView
        .environment(\.locale, persistenceController.locale)
        .environment(\.managedObjectContext, viewContext)
        .environmentObject(subscriptionManager)
        .onAppear {
            updateSubscriptionPrompt()
        }
        .onChange(of: subscriptionManager.currentSubscription) {oldValue, _ in
            updateSubscriptionPrompt()
        }
        .sheet(isPresented: $showSubscriptionPrompt) {
            SubscriptionPlansView(currentSubscription: subscriptionManager.currentSubscription)
                .environmentObject(subscriptionManager)
        }
    } // Body
    
    // MARK: - Functions
    /// Creates a binding for the NavigationPath of a specific tab.
    /// - Parameter key: The identifier of the tab (e.g., "home", "favorites").
    /// - Returns: A binding to the NavigationPath for the specified tab.
    private func pathBinding(for key: String) -> Binding<NavigationPath> {
        Binding<NavigationPath>(
            get: { tabPaths[key] ?? NavigationPath() },
            set: { tabPaths[key] = $0 }
        ) // Binding
    } // Function: pathBinding
    
    /// Updates the subscription prompt visibility.
    private func updateSubscriptionPrompt() {
        showSubscriptionPrompt = subscriptionManager.shouldPromptForSubscription()
    }
} // MainTabView

// MARK: - Preview
#Preview {
    NavigationStack {
        MainTabView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(ThemeManager())
            .environmentObject(PersistenceController.preview)
            .environmentObject(SubscriptionManager())
    } // NavigationStack
} // Preview
