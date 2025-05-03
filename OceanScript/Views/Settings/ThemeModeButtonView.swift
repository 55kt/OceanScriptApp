//
//  ThemeModeButtonView.swift
//  OceanScript
//
//  Created by Vlad on 3/5/25.
//

import SwiftUI

struct ThemeModeButtonView: View {
    let mode: ThemeMode
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            let backgroundColor = isSelected ? Color.accentColor.opacity(0.1) : Color.gray.opacity(0.1)
            let borderColor = isSelected ? Color.accentColor : Color.gray
            let contentColor = isSelected ? Color.accentColor : .gray
            
            VStack {
                Image(systemName: mode.iconName)
                    .font(.title2)
                    .foregroundStyle(contentColor)
                    .scaleEffect(isSelected ? 1.2 : 1.0)
                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isSelected)
                
                Text(mode.rawValue)
                    .font(.caption)
                    .foregroundStyle(contentColor)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor, lineWidth: 1)
            )
        }
        .padding(.horizontal, 10)
        .buttonStyle(.plain)
    }
}

#Preview {
    ThemeModeButtonView(mode: .light, isSelected: true, action: {})
}
