//
//  SupportSection.swift
//  OceanScript
//
//  Created by Vlad on 8/5/25.
//

import SwiftUI

// MARK: - View
/// A view displaying the support section in settings.
struct SupportSection: View {
    // MARK: - Properties
    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String = ""
    
    private let supportMailManager = SupportMailManager()
    private let supportEmail: String
    
    // MARK: - Initializer
    init(supportEmail: String) {
        self.supportEmail = supportEmail
    }
    
    // MARK: - Body
    var body: some View {
        Section(header: Text(LocalizedStringKey("Support"))) {
            Button(action: {
                supportMailManager.sendSupportEmail(
                    message: "Please describe your issue or feedback here.",
                    recipient: supportEmail
                ) { result in
                    switch result {
                    case .success:
                        break // Email sent successfully
                    case .failure(let error):
                        // Show alert only for specific errors, not for cancellation
                        if (error as? SupportMailError) != .userSavedDraft {
                            errorMessage = error.localizedDescription
                            showErrorAlert = true
                        }
                    }
                }
            }) {
                HStack {
                    Text(LocalizedStringKey("OceanScript Support"))
                        .font(.headline)
                    Spacer()
                    
                    Image(systemName: "envelope")
                        .resizable()
                        .frame(width: 30, height: 20)
                } // HStack
            }
            .accessibilityLabel("OceanScript support button")
            .accessibilityHint("Tap to contact support via email")
        } // Section
        .alert(isPresented: $showErrorAlert) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    } // Body
} // SupportSection

// MARK: - Preview
#Preview {
    SupportSection(supportEmail: "support@oceanscript.com")
}
