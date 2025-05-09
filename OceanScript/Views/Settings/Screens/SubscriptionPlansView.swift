//
//  SubscriptionPlansView.swift
//  OceanScript
//
//  Created by Vlad on 9/5/25.
//

import SwiftUI
import StoreKit

// MARK: - View
/// A static view displaying the subscription plans UI using SubscriptionStoreView (placeholder).
struct SubscriptionPlansView: View {
    // MARK: - Properties
    @StateObject private var storeKit = StoreKitManager()
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            // Placeholder group ID for SubscriptionStoreView
            SubscriptionStoreView(groupID: storeKit.groupId)
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        SubscriptionPlansView()
    }
}
