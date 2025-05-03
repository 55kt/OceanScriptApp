//
//  AppearanceSectionView.swift
//  OceanScript
//
//  Created by Vlad on 3/5/25.
//

import SwiftUI

struct AppearanceSectionView: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - body
    var body: some View {
        Section(header: Text("Appearance")) {
            HStack(spacing: 0) {
                ForEach(ThemeMode.allCases, id: \.self) { mode in
                    ThemeModeButtonView(
                        mode: mode,
                        isSelected: themeManager.themeMode == mode,
                        action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                themeManager.themeMode = mode
                            }
                        }
                    )
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        Form {
            AppearanceSectionView()
                .environmentObject(ThemeManager())
        }
    }
}
