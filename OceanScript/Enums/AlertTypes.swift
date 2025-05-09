//
//  AlertTypes.swift
//  OceanScript
//
//  Created by Vlad on 9/5/25.
//

import Foundation
import StoreKit

/// Defines the types of alerts used in SubscriptionPlansView.
enum AlertType: Identifiable {
    case purchaseCompleted
    case cancelSubscription
    case purchaseConfirmation(Product)
    case switchConfirmation
    case noSubscriptionsFound
    case restoreConfirmation
    case purchaseFailed
    
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
        case .purchaseFailed:
            return "purchaseFailed"
        }
    }
}
