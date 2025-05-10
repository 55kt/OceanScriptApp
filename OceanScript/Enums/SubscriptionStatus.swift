//
//  SubscriptionStatus.swift
//  OceanScript
//
//  Created by Vlad on 9/5/25.
//

import Foundation
import SwiftUI

/// Represents the status of a user's subscription.
enum SubscriptionStatus: String, CaseIterable {
    case noActiveSubscription = "No active subscription"
    case monthlyActive = "Monthly (active)"
    case yearlyActive = "Yearly (active)"
    
    /// Localized display name for the subscription status.
    var displayName: String {
        switch self {
        case .noActiveSubscription:
            return NSLocalizedString("No active subscription", comment: "No active subscription status")
        case .monthlyActive:
            return NSLocalizedString("Monthly (active)", comment: "Monthly subscription active status")
        case .yearlyActive:
            return NSLocalizedString("Yearly (active)", comment: "Yearly subscription active status")
        }
    }
}
