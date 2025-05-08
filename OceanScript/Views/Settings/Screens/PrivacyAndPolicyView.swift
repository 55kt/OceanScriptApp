//
//  PrivacyAndPolicyView.swift
//  OceanScript
//
//  Created by Vlad on 8/5/25.
//

import SwiftUI

// MARK: - Struct
/// A struct to decode the Privacy & Policy content from JSON.
struct PrivacyPolicyContent: Codable {
    let title: String
    let content: String
}

// MARK: - View
/// A view displaying the privacy policy of the OceanScript app.
struct PrivacyAndPolicyView: View {
    // MARK: - Properties
    @EnvironmentObject private var persistenceController: PersistenceController
    @Environment(\.dismiss) private var dismiss
    
    @State private var policyContent: PrivacyPolicyContent?
    
    // MARK: - Body
    var body: some View {
        NavigationStack { // NavigationStack
            ScrollView { // ScrollView
                if let policyContent = policyContent {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(policyContent.title)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(policyContent.content)
                            .font(.body)
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                    .accessibilityLabel("Privacy and Policy content")
                } else {
                    Text("Loading Privacy & Policy...")
                        .foregroundStyle(.secondary)
                        .padding()
                }
            } // ScrollView
            .navigationTitle("Privacy & Policy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { // Toolbar
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .accessibilityLabel("Done button")
                    .accessibilityHint("Tap to dismiss the Privacy & Policy sheet")
                }
            } // Toolbar
            .onAppear {
                loadPrivacyPolicy()
            }
        } // NavigationStack
    }
    
    // MARK: - Private Methods
    
    /// Loads the Privacy & Policy content from the appropriate JSON file based on the current language.
    private func loadPrivacyPolicy() {
        // Determine the language file to load
        let languageCode = persistenceController.currentLanguage
        let fileName = "privacy_\(languageCode)"
        
        // Load the JSON file from the bundle (root directory)
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json", subdirectory: nil) ??
               Bundle.main.url(forResource: "privacy_en", withExtension: "json", subdirectory: nil) else {
            print("Failed to locate \(fileName).json or fallback privacy_en.json in bundle.")
            return
        }
        
        loadContent(from: url)
    }
    
    /// Loads and decodes the Privacy & Policy content from the given URL.
    private func loadContent(from url: URL) {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let content = try decoder.decode(PrivacyPolicyContent.self, from: data)
            self.policyContent = content
        } catch {
            print("Failed to load or decode Privacy & Policy content: \(error)")
        }
    }
}

// MARK: - Preview
#Preview {
    PrivacyAndPolicyView()
        .environmentObject(PersistenceController.preview)
}
