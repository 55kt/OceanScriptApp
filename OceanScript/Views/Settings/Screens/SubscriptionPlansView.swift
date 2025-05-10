//
//  SubscriptionPlansView.swift
//  OceanScript
//
//  Created by Vlad on 9/5/25.
//

import SwiftUI
import StoreKit

// MARK: - View
/// A view displaying the subscription plans UI using SubscriptionStoreView.
struct SubscriptionPlansView: View {
    // MARK: - Properties
    @EnvironmentObject private var storeKit: StoreKitManager
    @State private var manageSubscriptionsSheet: Bool = false
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            SubscriptionStoreView(groupID: storeKit.groupId)
                .storeButton(.hidden, for: .cancellation)
            
            // Manage subscriptions button
            Button("Manage Subscription") {
                manageSubscriptionsSheet = true
            }
            .manageSubscriptionsSheet(isPresented: $manageSubscriptionsSheet, subscriptionGroupID: storeKit.groupId)
            .onChange(of: manageSubscriptionsSheet) {oldValue, newValue in
                if !newValue {
                    // Sheet was dismissed, update subscription status
                    Task {
                        await storeKit.updateCustomerSubscriptionStatus()
                    }
                }
            }
        }
        .onAppear {
            print("SubscriptionPlansView: Using StoreKitManager with groupId: \(storeKit.groupId)")
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        SubscriptionPlansView()
            .environmentObject(StoreKitManager())
    }
}
