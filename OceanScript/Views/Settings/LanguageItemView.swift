//
//  LanguageItemView.swift
//  OceanScript
//
//  Created by Vlad on 7/5/25.
//

import SwiftUI

// MARK: - View
struct LanguageItemView: View {
    // MARK: - Properties
    let language: SupportedLanguage
    let isSelected: Bool
    let isLoading: Bool
    let action: () -> Void
    
    // MARK: - Body
    var body: some View {
        Button(action: action) { // Button
            let englishNameColor: Color = isSelected ? .blue : .primary
            let nativeNameColor: Color = isSelected ? .blue.opacity(0.7) : .secondary
            
            HStack { // HStack
                VStack(alignment: .leading, spacing: 4) { // VStack
                    Text(language.englishName)
                        .font(.headline)
                        .foregroundStyle(englishNameColor)
                        .accessibilityLabel("Language: \(language.englishName)")
                    Text(language.nativeName)
                        .font(.subheadline)
                        .foregroundStyle(nativeNameColor)
                        .accessibilityLabel("Native name: \(language.nativeName)")
                } // VStack
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundStyle(Color.blue)
                }
            } // HStack
            .padding(.vertical, 6)
        } // Button
        .disabled(isLoading || isSelected)
        .accessibilityHint(isSelected ? "Language already selected" : "Tap to select \(language.englishName)")
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
    } // Body
} // LanguageItemView

// MARK: - Preview
#Preview {
    LanguageItemView(
        language: SupportedLanguage(rawValue: "en")!,
        isSelected: true,
        isLoading: false,
        action: {}
    )
} // Preview
