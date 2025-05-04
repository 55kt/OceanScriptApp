//
//  LanguageSelectionView.swift
//  OceanScript
//
//  Created by Vlad on 4/5/25.
//

import SwiftUI

struct LanguageSelectionView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading: Bool = false
    
    var body: some View {
        ZStack {
            List {
                ForEach(1...10, id: \.self) { text in
                    Button {
                        // action
                    } label: {
                        HStack {
                            VStack {
                                Text("English")
                                    .font(.headline)
                                Text("English")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "checkmark")
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .font(.title2)
                            .bold()
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Language Selection")
            .navigationBarTitleDisplayMode(.inline)
            .disabled(isLoading)
            
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2.0)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    LanguageSelectionView()
}
