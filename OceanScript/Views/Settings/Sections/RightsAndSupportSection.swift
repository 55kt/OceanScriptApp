//
//  RightsAndSupportSection.swift
//  OceanScript
//
//  Created by Vlad on 8/5/25.
//

import SwiftUI

// MARK: - View
/// A view displaying the rights and support section with Privacy and Policy and Copyright information.
struct RightsAndSupportSection: View {
    // MARK: - Properties
    @Binding var privacyPolicySheet: Bool
    
    // MARK: - Body
    var body: some View {
        Section(header: Text(LocalizedStringKey("Privacy & Rights"))) {
            VStack {
                // Show Privacy and Policy sheet
                Button(action: {
                    privacyPolicySheet.toggle()
                }) {
                    Text("Privacy and Policy")
                        .foregroundStyle(.blue)
                }
                .accessibilityLabel("Privacy and Policy button")
                .accessibilityHint("Tap to view the Privacy and Policy")
                
                // Copyright information
                CopyrightSection()
                    .padding(.top, 6)
            } // VStack
            .frame(maxWidth: .infinity, alignment: .center)
        } // Section
    } // Body
} // RightsAndSupportSection

// MARK: - Preview
#Preview {
    RightsAndSupportSection(privacyPolicySheet: .constant(false))
}
