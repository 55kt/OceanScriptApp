//
//  SubscriptionPlansSection.swift
//  OceanScript
//
//  Created by Vlad on 9/5/25.
//

import SwiftUI

// MARK: - View
/// A static view displaying the subscription plans section in settings (placeholder).
struct SubscriptionPlansSection: View {
    // MARK: - Body
    var body: some View {
        Section(header: Text(LocalizedStringKey("Subscription"))) {
            NavigationLink {
                SubscriptionPlansView()
            } label: {
                HStack {
                    Text(LocalizedStringKey("Subscription Plan"))
                        .font(.headline)
                        .accessibilityLabel("Subscription plan label")
                    
                    Spacer()
                    
                    Text("Placeholder Plan")
                        .foregroundStyle(.secondary)
                        .accessibilityLabel("Current subscription plan: Placeholder Plan")
                }
            }
            .accessibilityHint("Tap to manage your subscription plan")
            .accessibilityValue("Placeholder Plan")
        }
    }
}

// MARK: - Preview
#Preview {
    SubscriptionPlansSection()
}
