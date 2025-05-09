//
//  SettingsTabView.swift
//  OceanScript
//
//  Created by Vlad on 3/5/25.
//

import SwiftUI

// MARK: - View
struct SettingsTabView: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var persistenceController: PersistenceController
    @EnvironmentObject private var subscriptionManager: SubscriptionManager
    @Environment(\.managedObjectContext) private var viewContext
    
    // MARK: - Private Properties
    // Helper to get the localized language name
    private var currentLanguageName: String {
        SupportedLanguage(rawValue: persistenceController.currentLanguage)?.nativeName ?? "Unknown"
    }
    
    @State private var privacyPolicySheet: Bool = false
    
    private let supportEmail = "support@oceanscript.com" // Replace with actual support email
    
    // Test data for current subscription (will be replaced with real data later)
    private var currentSubscription: String {
        // Placeholder: In a real app, this would be fetched from StoreKit or a backend
        return "No active subscription"
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            Form {
                AppearanceSectionView()
                
                LanguageSelectionSection(currentLanguageName: currentLanguageName)
                
                SupportSection(supportEmail: supportEmail)
                
                SubscriptionPlansSection()
                                    .environmentObject(subscriptionManager)
                
                RightsAndPrivacySection(privacyPolicySheet: $privacyPolicySheet)
            } // Form
            .navigationTitle(Text(LocalizedStringKey("Settings")))
            .navigationBarTitleDisplayMode(.inline)
            .accessibilityLabel("Settings screen")
            .sheet(isPresented: $privacyPolicySheet) {
                PrivacyAndPolicyView()
                    .environmentObject(persistenceController)
            }
        } // NavigationStack
        .environment(\.locale, persistenceController.locale)
    } // Body
} // SettingsTabView

// MARK: - Preview
#Preview {
    NavigationStack {
        SettingsTabView()
            .environmentObject(ThemeManager())
            .environmentObject(PersistenceController.preview)
            .environmentObject(SubscriptionManager())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
