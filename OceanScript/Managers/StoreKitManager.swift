//
//  StoreKitManager.swift
//  OceanScript
//
//  Created by Vlad on 9/5/25.
//

import Foundation
import StoreKit

class StoreKitManager: ObservableObject {
    let subscriptionIds = ["com.oceanscript.monthly", "com.oceanscript.yearly"]
    let groupId = "A6F84B0F"
    
    @Published private(set) var subscriptions: [Product] = []
    @Published private(set) var purchasedSubscriptions: [Product] = []
    @Published private(set) var subscriptionStatus: SubscriptionStatus = .noActiveSubscription
    
    init() {
        Task {
            await requestSubscriptions()
            await updateCustomerSubscriptionStatus()
        }
    }
    
    @MainActor
    func requestSubscriptions() async {
        do {
            let appSubscriptions = try await Product.products(for: subscriptionIds)
            
            subscriptions = appSubscriptions.filter { subscription in
                switch subscription.type {
                case .autoRenewable:
                    return true
                default:
                    print("Unknown subscription type: \(subscription.type)")
                    return false
                }
            }
        } catch {
            print("Error requesting subscriptions: \(error)")
        }
    }
    
    @MainActor
    func updateCustomerSubscriptionStatus() async {
        var purchasedSubscriptions: [Product] = []
        
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerifed(result)
                
                switch transaction.productType {
                case .autoRenewable:
                    if let subscription = subscriptions.first(where: { $0.id == transaction.productID }) {
                        purchasedSubscriptions.append(subscription)
                    }
                default:
                    break
                }
            } catch {
                print("Error verifying transaction: \(error)")
            }
        }
        
        self.purchasedSubscriptions = purchasedSubscriptions
        
        // Update subscription status based on purchased subscriptions
        if let activeSubscription = purchasedSubscriptions.first {
            switch activeSubscription.id {
            case "com.oceanscript.monthly":
                subscriptionStatus = .monthlyActive
            case "com.oceanscript.yearly":
                subscriptionStatus = .yearlyActive
            default:
                subscriptionStatus = .noActiveSubscription
            }
        } else {
            subscriptionStatus = .noActiveSubscription
        }
    }
    
    func checkVerifed<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
    
    public enum StoreError: Error {
        case failedVerification
    }
}
