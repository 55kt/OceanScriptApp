//
//  TestResultView.swift
//  OceanScript
//
//  Created by Vlad on 2/5/25.
//

import SwiftUI

// MARK: - View
struct TestResultView: View {
    // MARK: - Properties
    let testTime: TimeInterval
    let totalQuestions: Int
    let correctAnswers: Int
    let incorrectAnswers: Int
    let testResults: [QuestionResult]
    @Binding var testPath: NavigationPath
    
    @State private var showQuestionList: Bool = false
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 20) { // VStack
            Text(LocalizedStringKey("Test Results"))
                .font(.largeTitle)
                .fontWeight(.bold)
                .accessibilityLabel("Test results")
            
            Text("Time: \(formatTime(testTime))")
                .font(.title2)
                .foregroundStyle(.gray)
                .accessibilityLabel("Test time: \(formatTime(testTime))")
            
            VStack(spacing: 10) { // VStack
                Text("Total Questions: \(totalQuestions)")
                    .font(.title3)
                    .accessibilityLabel("Total questions: \(totalQuestions)")
                Text("Correct Answers: \(correctAnswers)")
                    .font(.title3)
                    .foregroundStyle(.green)
                    .accessibilityLabel("Correct answers: \(correctAnswers)")
                Text("Incorrect Answers: \(incorrectAnswers)")
                    .font(.title3)
                    .foregroundStyle(.red)
                    .accessibilityLabel("Incorrect answers: \(incorrectAnswers)")
            } // VStack
            
            let percentage = totalQuestions > 0 ? Double(correctAnswers) / Double(totalQuestions) * 100 : 0
            Text(TestResultMessage.message(forCorrectPercentage: percentage).rawValue)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.blue)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .accessibilityLabel("Result message: \(TestResultMessage.message(forCorrectPercentage: percentage).rawValue)")
                .accessibilityValue("\(String(format: "%.0f", percentage))% correct")
            
            PrimaryButton(
                title: "View Question List", backgroundColor: .blue,
                action: { showQuestionList = true },
                isDisabled: false
            )
            
            PrimaryButton(
                title: "Try Again", backgroundColor: .blue,
                action: { testPath.removeLast(testPath.count) },
                isDisabled: false
            )
            
            Spacer()
        } // VStack
        .padding(.vertical)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            print("🔍 TestResultView appeared with testTime: \(testTime)")
        }
        .sheet(isPresented: $showQuestionList) { // sheet
            AnsweredQuestionList(testResults: testResults)
                .presentationDetents([.medium, .large])
        } // sheet
    } // Body
    
    // MARK: - Private Methods
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
} // TestResultView

// MARK: - Preview
#Preview {
    TestResultView(
        testTime: 123,
        totalQuestions: 10,
        correctAnswers: 8,
        incorrectAnswers: 2,
        testResults: [],
        testPath: .constant(NavigationPath())
    )
} // Preview
