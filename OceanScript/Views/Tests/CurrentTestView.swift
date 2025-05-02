//
//  CurrentTestView.swift
//  OceanScript
//
//  Created by Vlad on 2/5/25.
//

import SwiftUI

struct CurrentTestView: View {
    @StateObject private var viewModel: TestViewModel
    @Environment(\.dismiss) private var dismiss
    @Binding var testPath: NavigationPath
    
    @State private var showStopAlert: Bool = false
    @State private var isAnswerSelected: Bool = false
    @State private var testTime: TimeInterval = 0
    @State private var testCorrectAnswers: Int = 0
    @State private var testIncorrectAnswers: Int = 0
    
    let numberOfQuestions: Int
    
    init(numberOfQuestions: Int, testPath: Binding<NavigationPath>) {
        self.numberOfQuestions = numberOfQuestions
        self._testPath = testPath
        self._viewModel = StateObject(wrappedValue: TestViewModel(context: PersistenceController.shared.container.viewContext))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            // MARK: - Timer
            TimerView(formattedTime: viewModel.formattedTime())
            
            // MARK: - Progress
            Text("Question \(viewModel.currentQuestionIndex + 1)/\(viewModel.testQuestions.count)")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            // MARK: - Current Question
            if let question = viewModel.getCurrentQuestion() {
                VStack(spacing: 10) {
                    Image(systemName: question.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.blue)
                    
                    Text(question.name)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                // MARK: - Answer Options
                ForEach(viewModel.answerOptions, id: \.text) { option in
                    AnswerButtonView(
                        option: option,
                        isSelected: viewModel.selectedAnswer == option,
                        isAnswerSelected: isAnswerSelected,
                        action: {
                            viewModel.selectAnswer(option)
                            isAnswerSelected = true
                            
                            // MARK: - Delay before moving to the next question
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                if viewModel.moveToNextQuestion() {
                                    isAnswerSelected = false
                                } else {
                                    let (time, correct, incorrect) = viewModel.stopTest()
                                    testTime = time
                                    testCorrectAnswers = correct
                                    testIncorrectAnswers = incorrect
                                    testPath.append(TestNavigation.result(
                                        testTime: time,
                                        totalQuestions: viewModel.testQuestions.count,
                                        correctAnswers: correct,
                                        incorrectAnswers: incorrect,
                                        testResults: viewModel.getTestResults()
                                    ))
                                }
                            }
                        }
                    )
                }
            } else {
                Text("Loading question...")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.vertical)
        .navigationTitle("Test")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showStopAlert = true
                }) {
                    Image(systemName: "stop.circle")
                        .foregroundColor(.red)
                }
            }
        }
        .alert("Stop Test?", isPresented: $showStopAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Stop", role: .destructive) {
                testPath.removeLast(testPath.count)
            }
        } message: {
            Text("All data will be lost. Are you sure?")
        }
        .onAppear {
            viewModel.startTest(numberOfQuestions: numberOfQuestions)
        }
        .onDisappear {
            if !showStopAlert {
                viewModel.stopTest()
            }
        }
    }
}

#Preview {
    NavigationStack {
        CurrentTestView(numberOfQuestions: 10, testPath: .constant(NavigationPath()))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
