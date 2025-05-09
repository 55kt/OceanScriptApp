//
//  SubscriptionManager.swift
//  OceanScript
//
//  Created by Vlad on 9/5/25.
//

import Foundation

/// Manages subscription-related operations and trial status.
class SubscriptionManager: ObservableObject {
    // MARK: - Properties
    @Published private(set) var subscriptions: [Subscription] = []
    @Published private(set) var currentSubscription: String = "No active subscription"
    @Published private(set) var hasUsedTrial: Bool = false
    @Published private(set) var trialEndDate: Date?
    @Published private(set) var subscriptionEndDate: Date?
    
    private let hasUsedTrialKey = "hasUsedTrial"
    private let trialEndDateKey = "trialEndDate"
    private let subscriptionEndDateKey = "subscriptionEndDate"
    private let hasActiveSubscriptionKey = "hasActiveSubscription"
    private let hasPreviousSubscriptionKey = "hasPreviousSubscription"
    
    // Test data for subscriptions
    private var testSubscriptions: [Subscription] = [
        Subscription(
            id: "com.oceanscript.monthly",
            name: "Monthly",
            description: "Access all features for one month. Includes a 7-day free trial.",
            price: "$1.99/month",
            isActive: false
        ),
        Subscription(
            id: "com.oceanscript.yearly",
            name: "Yearly",
            description: "Access all features for one year. Includes a 7-day free trial.",
            price: "$9.99/year",
            isActive: false
        )
    ]
    
    // MARK: - Initializers
    init() {
        loadTrialStatus()
        loadSubscriptionEndDate()
        subscriptions = testSubscriptions
        Task { @MainActor in
            updateCurrentSubscription()
        }
    }
    
    // MARK: - Methods
    
    /// Loads the trial status from UserDefaults.
    private func loadTrialStatus() {
        hasUsedTrial = UserDefaults.standard.bool(forKey: hasUsedTrialKey)
        if let savedTrialEndDate = UserDefaults.standard.object(forKey: trialEndDateKey) as? Date {
            trialEndDate = savedTrialEndDate
        }
        
        // Automatically start trial for new users
        if !hasUsedTrial {
            Task { @MainActor in
                startTrial()
            }
        }
    }
    
    /// Loads the subscription end date from UserDefaults.
    private func loadSubscriptionEndDate() {
        if let savedEndDate = UserDefaults.standard.object(forKey: subscriptionEndDateKey) as? Date {
            subscriptionEndDate = savedEndDate
        }
    }
    
    /// Starts a 7-day trial period for new users.
    @MainActor
    private func startTrial() {
        hasUsedTrial = true
        trialEndDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())
        
        UserDefaults.standard.set(hasUsedTrial, forKey: hasUsedTrialKey)
        UserDefaults.standard.set(trialEndDate, forKey: trialEndDateKey)
        UserDefaults.standard.synchronize()
        
        updateCurrentSubscription()
    }
    
    /// Updates the current subscription status based on trial or active subscription.
    @MainActor
    private func updateCurrentSubscription() {
        if UserDefaults.standard.bool(forKey: hasActiveSubscriptionKey) {
            // Find the active subscription
            if let activeSubscription = subscriptions.first(where: { $0.isActive }) {
                if let subscriptionEndDate = subscriptionEndDate, subscriptionEndDate > Date() {
                    currentSubscription = "\(activeSubscription.name) (ends on \(formattedDate(subscriptionEndDate)))"
                } else {
                    currentSubscription = "No active subscription"
                    UserDefaults.standard.set(false, forKey: hasActiveSubscriptionKey)
                    subscriptions = subscriptions.map { subscription in
                        var updatedSubscription = subscription
                        updatedSubscription.isActive = false
                        return updatedSubscription
                    }
                }
            } else {
                currentSubscription = "No active subscription"
                UserDefaults.standard.set(false, forKey: hasActiveSubscriptionKey)
            }
        } else if let trialEndDate = trialEndDate, trialEndDate > Date() {
            currentSubscription = "Trial (ends on \(formattedDate(trialEndDate)))"
        } else {
            currentSubscription = "No active subscription"
        }
    }
    
    /// Checks if there are previous subscriptions.
    func hasPreviousSubscriptions() -> Bool {
        return UserDefaults.standard.bool(forKey: hasPreviousSubscriptionKey)
    }
    
    /// Restores purchases (to be replaced with StoreKit).
    @MainActor
    func restorePurchases() async throws {
        // Placeholder: In a real app, this would call AppStore.sync()
        // For now, simulate restoring an active subscription
        if UserDefaults.standard.bool(forKey: hasPreviousSubscriptionKey) {
            UserDefaults.standard.set(true, forKey: hasActiveSubscriptionKey)
            UserDefaults.standard.removeObject(forKey: subscriptionEndDateKey)
            UserDefaults.standard.synchronize()
            
            // Simulate restoring an active subscription (e.g., Monthly)
            subscriptions = subscriptions.map { subscription in
                var updatedSubscription = subscription
                if subscription.id == "com.oceanscript.monthly" {
                    updatedSubscription.isActive = true
                } else {
                    updatedSubscription.isActive = false
                }
                return updatedSubscription
            }
            
            // Simulate setting an end date (e.g., 30 days from now for Monthly)
            subscriptionEndDate = Calendar.current.date(byAdding: .day, value: 30, to: Date())
            UserDefaults.standard.set(subscriptionEndDate, forKey: subscriptionEndDateKey)
            UserDefaults.standard.synchronize()
            
            updateCurrentSubscription()
        }
    }
    
    /// Simulates cancelling a subscription (to be replaced with StoreKit).
    @MainActor
    func cancelSubscription() async {
        // Reset active status for all subscriptions
        subscriptions = subscriptions.map { subscription in
            var updatedSubscription = subscription
            updatedSubscription.isActive = false
            return updatedSubscription
        }
        
        UserDefaults.standard.set(true, forKey: hasActiveSubscriptionKey)
        UserDefaults.standard.synchronize()
        
        updateCurrentSubscription()
    }
    
    /// Calculates remaining days from the current subscription.
    func calculateRemainingDays() -> Int {
        guard let endDate = subscriptionEndDate else { return 0 }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: endDate)
        return max(0, components.day ?? 0)
    }
    
    /// Simulates purchasing a subscription (to be replaced with StoreKit).
    @MainActor
    func purchaseSubscription(_ subscription: Subscription, additionalDays: Int = 0) async {
        // Reset trial period
        trialEndDate = nil
        UserDefaults.standard.removeObject(forKey: trialEndDateKey)
        UserDefaults.standard.set(true, forKey: hasPreviousSubscriptionKey)
        UserDefaults.standard.synchronize()
        
        // Update the active status for subscriptions
        subscriptions = subscriptions.map { sub in
            var updatedSub = sub
            updatedSub.isActive = (sub.id == subscription.id)
            return updatedSub
        }
        
        UserDefaults.standard.set(true, forKey: hasActiveSubscriptionKey)
        UserDefaults.standard.synchronize()
        
        // Set subscription end date based on the plan
        let baseEndDate: Date
        if subscription.id == "com.oceanscript.monthly" {
            baseEndDate = Calendar.current.date(byAdding: .day, value: 30, to: Date())!
        } else if subscription.id == "com.oceanscript.yearly" {
            baseEndDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
        } else {
            baseEndDate = Date()
        }
        
        // Add remaining days from previous subscription
        subscriptionEndDate = Calendar.current.date(byAdding: .day, value: additionalDays, to: baseEndDate)
        UserDefaults.standard.set(subscriptionEndDate, forKey: subscriptionEndDateKey)
        UserDefaults.standard.synchronize()
        
        updateCurrentSubscription()
    }
    
    /// Checks if the user should be prompted to subscribe.
    func shouldPromptForSubscription() -> Bool {
        if let trialEndDate = trialEndDate, trialEndDate > Date() {
            return false // Trial is still active
        }
        if let subscriptionEndDate = subscriptionEndDate, subscriptionEndDate > Date() {
            return false // Subscription is still active
        }
        return !UserDefaults.standard.bool(forKey: hasActiveSubscriptionKey)
    }
    
    /// Formats a date to a readable string.
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
