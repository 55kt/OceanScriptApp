//
//  AnswerButtonView.swift
//  OceanScript
//
//  Created by Vlad on 2/5/25.
//

import SwiftUI

// MARK: - View
struct AnswerButtonView: View {
    // MARK: - Properties
    let option: AnswerOption
    let isSelected: Bool
    let isAnswerSelected: Bool
    let action: () -> Void
    
    // MARK: - Body
    var body: some View {
        Button(action: action) { // Button
            Text(option.text)
                .font(.body)
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(buttonColor)
                .cornerRadius(10)
                .shadow(
                    color: isSelected ? Color.black.opacity(0.3) : Color.clear,
                    radius: 5,
                    x: 0,
                    y: 3
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? Color.white : Color.clear, lineWidth: 2)
                )
                .padding(.horizontal)
        } // Button
        .disabled(isAnswerSelected)
        .accessibilityLabel("Answer: \(option.text)")
        .accessibilityHint(isSelected ? "Selected answer" : "Select this answer")
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
    } // Body
    
    // MARK: - Private Methods
    private var buttonColor: Color {
        isAnswerSelected ? (option.isCorrect ? .green : .red) : .blue
    }
} // AnswerButtonView

// MARK: - Preview
#Preview {
    AnswerButtonView(
        option: .correct("A programming language"),
        isSelected: true,
        isAnswerSelected: true,
        action: {}
    )
} // Preview
