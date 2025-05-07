//
//  AppearanceSectionView.swift
//  OceanScript
//
//  Created by Vlad on 3/5/25.
//

import SwiftUI

// MARK: - View
struct AppearanceSectionView: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - Body
    var body: some View {
        Section(header: Text(LocalizedStringKey("Appearance"))) { // Section
            HStack(spacing: 0) { // HStack
                ForEach(ThemeMode.allCases, id: \.self) { mode in // ForEach
                    ThemeModeButtonView(
                        mode: mode,
                        isSelected: themeManager.themeMode == mode,
                        action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                themeManager.themeMode = mode
                            }
                        }
                    )
                } // ForEach
            } // HStack
        } // Section
        .accessibilityLabel("Appearance settings section")
    } // Body
} // AppearanceSectionView

// MARK: - Preview
#Preview {
    NavigationStack { // NavigationStack
        Form { // Form
            AppearanceSectionView()
                .environmentObject(ThemeManager())
        } // Form
    } // NavigationStack
} // Preview
