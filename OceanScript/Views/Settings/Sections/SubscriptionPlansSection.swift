//
//  SubscriptionPlansSection.swift
//  OceanScript
//
//  Created by Vlad on 9/5/25.
//

import SwiftUI

// MARK: - View
struct SubscriptionPlansSection: View {
    // MARK: - Properties
    @EnvironmentObject private var storeKit: StoreKitManager
    
    // MARK: - Body
    var body: some View {
        Section(header: Text(LocalizedStringKey("Subscription"))) {
            NavigationLink(destination: SubscriptionPlansView().environmentObject(storeKit)) {
                HStack {
                    Text(LocalizedStringKey("Subscription Plan"))
                        .font(.headline)
                        .accessibilityLabel("Subscription plan label")
                    
                    Spacer()
                    
                    Text(storeKit.subscriptionStatus.displayName)
                        .foregroundStyle(.secondary)
                        .accessibilityLabel("Current subscription plan: Placeholder Plan")
                }// HStack
                .accessibilityHint("Tap to view subscription plan details")
                .accessibilityValue(storeKit.subscriptionStatus.displayName)
            }// NavigationLink
        }// Section
    }// Body
}// View

// MARK: - Preview
#Preview {
    SubscriptionPlansSection()
        .environmentObject(StoreKitManager())
}
