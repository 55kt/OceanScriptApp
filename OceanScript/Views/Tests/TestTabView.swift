//
//  TestTabView.swift
//  OceanScript
//
//  Created by Vlad on 2/5/25.
//

import SwiftUI

// MARK: - View
struct TestTabView: View {
    // MARK: - Properties
    @State private var numberOfQuestions: Int = 10
    @Binding var testPath: NavigationPath
    
    private let questionCounts: [Int] = [5, 10, 15, 20, 25, 30]
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 20) {
            Text(LocalizedStringKey("Start a New Test"))
                .font(.largeTitle)
                .fontWeight(.bold)
                .accessibilityLabel("Start a new test")
            
            Text(LocalizedStringKey("Select the number of questions for your test"))
                .font(.subheadline)
                .foregroundColor(.gray)
                .accessibilityLabel("Select the number of questions for your test")
            
            Picker("Number of Questions", selection: $numberOfQuestions) {
                ForEach(questionCounts, id: \.self) { count in
                    Text("\(count) questions")
                        .tag(count)
                } // ForEach
            } // Picker
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .accessibilityLabel("Number of questions picker")
            .accessibilityValue("\(numberOfQuestions) questions")
            
            Spacer()
            
            PrimaryButton(
                title: "Start Test",
                action: {
                    testPath.append(TestNavigation.test(numberOfQuestions: numberOfQuestions))
                },
                isDisabled: numberOfQuestions == 0
            )
        } // VStack
        .padding(.vertical)
        .navigationBarTitleDisplayMode(.inline)
    } // Body
} // TestTabView

// MARK: - Preview
#Preview {
    NavigationStack {
        TestTabView(testPath: .constant(NavigationPath()))
    } // NavigationStack
} // Preview
