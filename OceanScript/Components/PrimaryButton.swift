//
//  PrimaryButton.swift
//  OceanScript
//
//  Created by Vlad on 6/5/25.
//

import SwiftUI

// MARK: - View
struct PrimaryButton: View {
    // MARK: - Properties
    let title: String
    let action: () -> Void
    let isDisabled: Bool
    
    // MARK: - Body
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
        } // Button
        .padding(.horizontal)
        .disabled(isDisabled)
    } // Body
} // PrimaryButton

// MARK: - Preview
#Preview {
    PrimaryButton(title: "Start Test", action: {}, isDisabled: false)
} // Preview
