//
//  SubscriptionPlansSection.swift
//  OceanScript
//
//  Created by Vlad on 9/5/25.
//

import SwiftUI

// MARK: - View
/// A view displaying the subscription plans section in settings.
struct SubscriptionPlansSection: View {
    // MARK: - Properties
    @EnvironmentObject private var subscriptionManager: SubscriptionManager
    
    // MARK: - Body
    var body: some View {
        Section(header: Text(LocalizedStringKey("Subscription"))) {
            NavigationLink {
                SubscriptionPlansView(currentSubscription: subscriptionManager.currentSubscription)
                    .environmentObject(subscriptionManager)
            } label: {
                HStack {
                    Text(LocalizedStringKey("Subscription Plan"))
                        .font(.headline)
                        .accessibilityLabel("Subscription plan label")
                    
                    Spacer()
                    
                    Text(subscriptionManager.currentSubscription)
                        .foregroundStyle(.secondary)
                        .accessibilityLabel("Current subscription plan: \(subscriptionManager.currentSubscription)")
                } // HStack
            } // NavigationLink
            .accessibilityHint("Tap to manage your subscription plan")
            .accessibilityValue(subscriptionManager.currentSubscription)
        } // Section
    } // Body
} // SubscriptionPlansSection

// MARK: - Preview
#Preview {
    SubscriptionPlansSection()
        .environmentObject(SubscriptionManager())
}
