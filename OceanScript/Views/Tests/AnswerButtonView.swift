//
//  AnswerButtonView.swift
//  OceanScript
//
//  Created by Vlad on 2/5/25.
//

import SwiftUI

struct AnswerButtonView: View {
    let option: AnswerOption
    let isSelected: Bool
    let isAnswerSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(option.text)
                .font(.body)
                .foregroundColor(.white)
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
                    isSelected ?
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 2) :
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.clear, lineWidth: 0)
                )
                .padding(.horizontal)
        }
        .disabled(isAnswerSelected)
    }
    
    private var buttonColor: Color {
        guard isAnswerSelected else {
            return .blue
        }
        
        return option.isCorrect ? .green : .red
    }
}

#Preview {
    AnswerButtonView(
        option: .correct("A programming language"),
        isSelected: true,
        isAnswerSelected: true,
        action: {}
    )
}
