//
//  SubscriptionPlansView.swift
//  OceanScript
//
//  Created by Vlad on 9/5/25.
//

import SwiftUI

// MARK: - View
/// A static view displaying the subscription plans UI (placeholder).
struct SubscriptionPlansView: View {
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Current subscription status
                    VStack(alignment: .leading, spacing: 10) {
                        Text(LocalizedStringKey("Current Subscription"))
                            .font(.headline)
                            .foregroundStyle(.primary)
                        
                        Text("Placeholder Subscription")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Subscription plans
                    VStack(spacing: 10) {
                        SubscriptionPlanCard()
                        SubscriptionPlanCard()
                    }
                    .padding(.horizontal)
                    
                    // Restore Purchases button
                    Button(action: {}) {
                        Text(LocalizedStringKey("Restore Purchases"))
                            .foregroundStyle(.blue)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.horizontal)
                    .accessibilityLabel("Restore Purchases button")
                    .accessibilityHint("Tap to restore previously purchased subscriptions")
                }
                .padding(.vertical)
            }
            .navigationTitle(LocalizedStringKey("Subscriptions"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        SubscriptionPlansView()
    }
}
