//
//  PrimaryButton.swift
//  OceanScript
//
//  Created by Grok (xAI) on 06/05/2025.
//

import SwiftUI

// MARK: - View
struct PrimaryButton: View {
    // MARK: - Properties
    let title: String
    let backgroundColor: Color
    let action: () -> Void
    let isDisabled: Bool
    
    // MARK: - Body
    var body: some View {
        Button(action: action) { // Button
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(backgroundColor)
                .cornerRadius(10)
        } // Button
        .padding(.horizontal)
        .disabled(isDisabled)
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityHint("Tap to perform action")
        .accessibilityValue(isDisabled ? "Disabled" : "Enabled")
    } // Body
} // PrimaryButton

// MARK: - Preview
#Preview {
    PrimaryButton(
        title: "Start Test",
        backgroundColor: Color.blue,
        action: {},
        isDisabled: false
    )
} // Preview
