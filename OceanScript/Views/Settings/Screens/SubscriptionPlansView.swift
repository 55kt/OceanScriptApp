//
//  SubscriptionPlansView.swift
//  OceanScript
//
//  Created by Vlad on 9/5/25.
//

import SwiftUI

// MARK: - Alert Type
enum AlertType: Identifiable {
    case purchaseCompleted
    case cancelSubscription
    case purchaseConfirmation(Subscription)
    case switchConfirmation(Subscription)
    case noSubscriptionsFound
    case restoreConfirmation
    
    var id: String {
        switch self {
        case .purchaseCompleted:
            return "purchaseCompleted"
        case .cancelSubscription:
            return "cancelSubscription"
        case .purchaseConfirmation:
            return "purchaseConfirmation"
        case .switchConfirmation:
            return "switchConfirmation"
        case .noSubscriptionsFound:
            return "noSubscriptionsFound"
        case .restoreConfirmation:
            return "restoreConfirmation"
        }
    }
}

// MARK: - View
/// A view displaying available subscription plans.
struct SubscriptionPlansView: View {
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var subscriptionManager: SubscriptionManager
    @State private var alertType: AlertType?
    @State private var selectedSubscription: Subscription?
    let currentSubscription: String
    
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
                        
                        Text(currentSubscription)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Subscription plans
                    ForEach(subscriptionManager.subscriptions) { subscription in
                        SubscriptionPlanCard(subscription: subscription) {
                            print("Button pressed for \(subscription.name)")
                            if subscription.isActive {
                                // Show cancel alert
                                alertType = .cancelSubscription
                            } else {
                                // Check if another subscription is active
                                if subscriptionManager.subscriptions.contains(where: { $0.isActive }) {
                                    // Show switch confirmation
                                    selectedSubscription = subscription
                                    alertType = .switchConfirmation(subscription)
                                } else {
                                    // Show purchase confirmation
                                    selectedSubscription = subscription
                                    alertType = .purchaseConfirmation(subscription)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Restore Purchases button
                    Button(action: {
                        print("Restore Purchases button pressed")
                        if subscriptionManager.hasPreviousSubscriptions() {
                            alertType = .restoreConfirmation
                        } else {
                            alertType = .noSubscriptionsFound
                        }
                    }) {
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
            .alert(item: $alertType) { alertType in
                switch alertType {
                case .purchaseCompleted:
                    return Alert(
                        title: Text(LocalizedStringKey("Purchase completed")),
                        message: Text(LocalizedStringKey("You have successfully purchased a subscription!")),
                        dismissButton: .default(Text(LocalizedStringKey("OK")))
                    )
                case .cancelSubscription:
                    return Alert(
                        title: Text(LocalizedStringKey("Subscription Cancelled")),
                        message: Text(LocalizedStringKey("Your subscription will be paused, and at the end of the term, you will need to either renew the subscription or choose another one.")),
                        dismissButton: .default(Text(LocalizedStringKey("OK"))) {
                            Task {
                                await subscriptionManager.cancelSubscription()
                            }
                        }
                    )
                case .purchaseConfirmation(let subscription):
                    return Alert(
                        title: Text(LocalizedStringKey("Confirm Purchase")),
                        message: Text(LocalizedStringKey("You are about to subscribe to \(subscription.name). This will cost \(subscription.price) and auto-renew until cancelled.")),
                        primaryButton: .default(Text(LocalizedStringKey("Confirm"))) {
                            Task {
                                await subscriptionManager.purchaseSubscription(subscription)
                                self.alertType = .purchaseCompleted // Используем self.alertType
                            }
                        },
                        secondaryButton: .cancel()
                    )
                case .switchConfirmation(let subscription):
                    return Alert(
                        title: Text(LocalizedStringKey("Switch Subscription")),
                        message: Text(LocalizedStringKey("You already have an active subscription. You must cancel your current subscription before switching. Remaining days will be added to your new subscription.")),
                        primaryButton: .default(Text(LocalizedStringKey("Cancel Current Subscription"))) {
                            Task {
                                await subscriptionManager.cancelSubscription()
                                let remainingDays = subscriptionManager.calculateRemainingDays()
                                await subscriptionManager.purchaseSubscription(subscription, additionalDays: remainingDays)
                                self.alertType = .purchaseCompleted // Используем self.alertType
                            }
                        },
                        secondaryButton: .cancel()
                    )
                case .noSubscriptionsFound:
                    return Alert(
                        title: Text(LocalizedStringKey("No Subscriptions Found")),
                        message: Text(LocalizedStringKey("There are no previous subscriptions to restore.")),
                        dismissButton: .default(Text(LocalizedStringKey("OK")))
                    )
                case .restoreConfirmation:
                    return Alert(
                        title: Text(LocalizedStringKey("Restore Subscription")),
                        message: Text(LocalizedStringKey("Do you want to restore your previous subscription plan?")),
                        primaryButton: .default(Text(LocalizedStringKey("Confirm"))) {
                            Task {
                                try await subscriptionManager.restorePurchases()
                                self.alertType = .purchaseCompleted // Используем self.alertType
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
        }
    }
}

// MARK: - Subscription Plan Card
/// A card view for displaying a single subscription plan.
struct SubscriptionPlanCard: View {
    let subscription: Subscription
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(subscription.name)
                    .font(.title2)
                    .fontWeight(.bold)
                
                if subscription.isActive {
                    Text(LocalizedStringKey("Active"))
                        .foregroundStyle(.green)
                        .font(.headline)
                }
            }
            
            Text(subscription.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Text(subscription.price)
                .font(.headline)
                .foregroundStyle(.blue)
            
            Button(action: action) {
                Text(subscription.isActive ? LocalizedStringKey("Cancel Subscription") : LocalizedStringKey("Subscribe"))
                    .foregroundStyle(subscription.isActive ? .red : .white)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(subscription.isActive ? Color.red.opacity(0.2) : Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(subscription.name) subscription, \(subscription.isActive ? "active" : "inactive")")
        .accessibilityHint(subscription.isActive ? "Tap to cancel subscription" : "Tap to purchase this subscription")
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        SubscriptionPlansView(currentSubscription: "No active subscription")
            .environmentObject(SubscriptionManager())
    }
}
