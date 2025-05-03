//
//  ThemeManager.swift
//  OceanScript
//
//  Created by Vlad on 3/5/25.
//

import SwiftUI

// MARK: - Theme Mode Enum
// Defines the possible theme modes for the app
enum ThemeMode: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    case system = "System"
    
    // Returns the corresponding color scheme for the theme mode
    var colorScheme: ColorScheme? {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil // System mode uses the device's appearance settings
        }
    }
    
    // Returns the icon name for the theme mode
    var iconName: String {
        switch self {
        case .light:
            return "sun.max.fill"
        case .dark:
            return "moon.fill"
        case .system:
            return "gearshape.fill"
        }
    }
}

// MARK: - Theme Manager
// Manages the app's theme mode and persists it using AppStorage
class ThemeManager: ObservableObject {
    // MARK: - Properties
    @AppStorage("AppThemeMode") private var themeModeRaw: String = ThemeMode.system.rawValue
    @Published var themeMode: ThemeMode {
        didSet {
            themeModeRaw = themeMode.rawValue
            print("🔍 ThemeManager: Updated themeMode to \(themeMode.rawValue)") // Debug output
        }
    }
    
    // MARK: - Initialization
    // Initializes the theme manager with the stored theme mode or defaults to system
    init() {
        // Temporarily initialize themeMode to avoid accessing self before initialization
        self.themeMode = .system
        
        // Update themeMode based on the stored value
        if let storedMode = ThemeMode(rawValue: themeModeRaw) {
            self.themeMode = storedMode
        }
        
        print("🔍 ThemeManager: Initialized with themeMode \(themeMode.rawValue)") // Debug output
    }
    
    // MARK: - Methods
    // Applies the theme mode to the given window scene
    func applyTheme(to windowScene: UIWindowScene?) {
        guard let windowScene = windowScene else { return }
        windowScene.windows.forEach { window in
            window.overrideUserInterfaceStyle = themeMode == .system ? .unspecified : (themeMode == .light ? .light : .dark)
        }
        print("🔍 ThemeManager: Applied theme \(themeMode.rawValue) to window scene") // Debug output
    }
}
