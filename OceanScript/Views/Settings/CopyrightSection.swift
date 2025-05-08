//
//  CopyrightSection.swift
//  OceanScript
//
//  Created by Vlad on 8/5/25.
//

import SwiftUI

struct CopyrightSection: View {
    private let currentYear: String = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            return formatter.string(from: Date())
        }()

        var body: some View {
            Text("Copyright © \(currentYear) Volos Software LLC. All rights reserved")
                .multilineTextAlignment(.center)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
}

#Preview {
    CopyrightSection()
}
