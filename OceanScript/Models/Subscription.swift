//
//  Subscription.swift
//  OceanScript
//
//  Created by Vlad on 9/5/25.
//

import Foundation

/// Represents a subscription plan in the OceanScript app.
struct Subscription: Identifiable {
    // MARK: - Properties
    let id: String
    let name: String
    let description: String
    let price: String
    var isActive: Bool
    
    // MARK: - Initializers
    init(id: String, name: String, description: String, price: String, isActive: Bool = false) {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.isActive = isActive
    }
}
