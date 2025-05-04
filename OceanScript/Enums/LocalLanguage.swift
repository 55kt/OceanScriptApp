//
//  LocalLanguage.swift
//  OceanScript
//
//  Created by Vlad on 4/5/25.
//

import Foundation

// Supported languages for the app's interface
enum SupportedLanguage: String, CaseIterable, Identifiable {
    case en = "en"
    case ru = "ru"
    
    var id: String { self.rawValue }
    
    var englishName: String {
        switch self {
        case .en: return "English"
        case .ru: return "Russian"
        }
    }
    
    var nativeName: String {
        switch self {
        case .en: return "English"
        case .ru: return "Русский"
        }
    }
}
