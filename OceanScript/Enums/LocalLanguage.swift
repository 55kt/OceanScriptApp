//
//  LocalLanguage.swift
//  OceanScript
//
//  Created by Vlad on 4/5/25.
//

import Foundation

// MARK: - Enums

/// Represents the supported languages for the app's interface.
enum SupportedLanguage: String, CaseIterable, Identifiable {
    // MARK: - Cases
    case en = "en" // English
    case ru = "ru" // Russian
    
    // MARK: - Properties
    
    /// The identifier of the language, based on its raw value.
    var id: String { rawValue }
    
    /// A private dictionary mapping language codes to their English and native names.
    private static let languageNames: [String: (englishName: String, nativeName: String)] = [
        "en": ("English", "English"),
        "ru": ("Russian", "Русский")
    ]
    
    /// The name of the language in English.
    var englishName: String {
        Self.languageNames[rawValue]?.englishName ?? "Unknown"
    }
    
    /// The name of the language in its native form.
    var nativeName: String {
        Self.languageNames[rawValue]?.nativeName ?? "Unknown"
    }
} // SupportedLanguage
