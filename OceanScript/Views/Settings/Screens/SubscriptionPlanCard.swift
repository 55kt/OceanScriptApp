//
//  SubscriptionPlanCard.swift
//  OceanScript
//
//  Created by Vlad on 9/5/25.
//

import SwiftUI

/// A static card view for displaying a subscription plan (placeholder).
struct SubscriptionPlanCard: View {
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Plan Name")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(LocalizedStringKey("Active"))
                    .foregroundStyle(.green)
                    .font(.headline)
            }
            
            Text("Plan Description")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Text("Plan Price")
                .font(.headline)
                .foregroundStyle(.blue)
            
            Button(action: {}) {
                Text(LocalizedStringKey("Subscribe"))
                    .foregroundStyle(.white)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Placeholder subscription plan")
        .accessibilityHint("Tap to interact with the subscription plan")
    }
}

// MARK: - Preview
#Preview {
    SubscriptionPlanCard()
}
