//
//  ThemeManager.swift
//  OceanScript
//
//  Created by Vlad on 3/5/25.
//

import SwiftUI

// MARK: - Enums

/// Represents the possible theme modes for the app.
enum ThemeMode: String, CaseIterable {
    // MARK: - Cases
    case light = "Light"
    case dark = "Dark"
    case system = "System"
    
    // MARK: - Properties
    
    /// The corresponding color scheme for the theme mode.
    var colorScheme: ColorScheme? {
        self == .light ? .light : self == .dark ? .dark : nil
    }
    
    /// The icon name associated with the theme mode.
    var iconName: String {
        self == .light ? "sun.max.fill" : self == .dark ? "moon.fill" : "gearshape.fill"
    }
} // ThemeMode

// MARK: - Class
/// Manages the app's theme mode and persists it using AppStorage.
class ThemeManager: ObservableObject {
    // MARK: - Properties
    @AppStorage("AppThemeMode") private var themeModeRaw: String = ThemeMode.system.rawValue
    
    @Published var themeMode: ThemeMode {
        didSet {
            themeModeRaw = themeMode.rawValue
            logInfo("Updated themeMode to \(themeMode.rawValue)")
        }
    }
    
    // MARK: - Initializers
    /// Initializes the theme manager with the stored theme mode or defaults to system.
    init() {
        // Temporarily initialize themeMode to avoid accessing self before initialization
        self.themeMode = .system
        
        // Update themeMode based on the stored value
        if let storedMode = ThemeMode(rawValue: themeModeRaw) {
            self.themeMode = storedMode
        }
        
        logInfo("Initialized with themeMode \(themeMode.rawValue)")
    }
    
    // MARK: - Methods
    
    /// Applies the theme mode to the given window scene.
    /// - Parameter windowScene: The window scene to apply the theme to.
    func applyTheme(to windowScene: UIWindowScene?) {
        guard let windowScene else {
            logWarning("No window scene provided for applying theme")
            return
        }
        
        let userInterfaceStyle: UIUserInterfaceStyle = themeMode == .system ? .unspecified : (themeMode == .light ? .light : .dark)
        windowScene.windows.forEach { window in
            window.overrideUserInterfaceStyle = userInterfaceStyle
        }
        
        logInfo("Applied theme \(themeMode.rawValue) to window scene")
    }
    
    // MARK: - Logging Helpers
    
    /// Logs an informational message.
    /// - Parameter message: The message to log.
    private func logInfo(_ message: String) {
        #if DEBUG
        print("ℹ️ ThemeManager: \(message)")
        #endif
    }
    
    /// Logs a warning message.
    /// - Parameter message: The warning message to log.
    private func logWarning(_ message: String) {
        #if DEBUG
        print("⚠️ ThemeManager: \(message)")
        #endif
    }
} // ThemeManager
