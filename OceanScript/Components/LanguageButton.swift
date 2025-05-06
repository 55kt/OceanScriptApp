//
//  LanguageButton.swift
//  OceanScript
//
//  Created by Vlad on 6/5/25.
//

import SwiftUI

// MARK: - View
struct LanguageButton: View {
    // MARK: - Properties
    let title: String
    let backgroundColor: Color
    let action: () -> Void
    let isDisabled: Bool
    
    // MARK: - Body
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.title2)
                .padding()
                .frame(maxWidth: .infinity)
                .background(backgroundColor)
                .cornerRadius(10)
        } // Button
        .padding(.horizontal)
        .disabled(isDisabled)
        .buttonStyle(.plain)
    } // Body
} // LanguageButton

// MARK: - Preview
#Preview {
    LanguageButton(
        title: "Swift",
        backgroundColor: Color.blue.opacity(0.2),
        action: {},
        isDisabled: false
    )
} // Preview
