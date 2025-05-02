//
//  TestResultView.swift
//  OceanScript
//
//  Created by Vlad on 2/5/25.
//

import SwiftUI

struct TestResultView: View {
    let testTime: TimeInterval
    let totalQuestions: Int
    let correctAnswers: Int
    let incorrectAnswers: Int
    let testResults: [QuestionResult]
    @Binding var testPath: NavigationPath
    
    @State private var showQuestionList: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Test Results")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Time: \(formatTime(testTime))")
                .font(.title2)
                .foregroundColor(.gray)
            
            VStack(spacing: 10) {
                Text("Total Questions: \(totalQuestions)")
                    .font(.title3)
                Text("Correct Answers: \(correctAnswers)")
                    .font(.title3)
                    .foregroundColor(.green)
                Text("Incorrect Answers: \(incorrectAnswers)")
                    .font(.title3)
                    .foregroundColor(.red)
            }
            
            let percentage = totalQuestions > 0 ? Double(correctAnswers) / Double(totalQuestions) * 100 : 0
            Text(TestResultMessage.message(forCorrectPercentage: percentage).rawValue)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.blue)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: {
                showQuestionList = true
            }) {
                Text("View Question List")
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            
            Button(action: {
                testPath.removeLast(testPath.count)
            }) {
                Text("Try Again")
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
        .padding(.vertical)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            print("🔍 TestResultView appeared with testTime: \(testTime)")
        }
        .sheet(isPresented: $showQuestionList) {
            List {
                ForEach(testResults, id: \.self) { result in
                    if let question = result.question {
                        HStack {
                            Text(question.name)
                                .font(.body)
                            Spacer()
                            Image(systemName: result.isAnsweredCorrectly ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(result.isAnsweredCorrectly ? .green : .red)
                        }
                    }
                }
            }
            .padding()
            .presentationDetents([.medium, .large])
        }
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    TestResultView(
        testTime: 123,
        totalQuestions: 10,
        correctAnswers: 8,
        incorrectAnswers: 2,
        testResults: [],
        testPath: .constant(NavigationPath())
    )
}
