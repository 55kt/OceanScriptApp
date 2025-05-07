//
//  CurrentTestView.swift
//  OceanScript
//
//  Created by Vlad on 2/5/25.
//

import SwiftUI

// MARK: - View
struct CurrentTestView: View {
    // MARK: - Properties
    @StateObject private var viewModel: TestViewModel
    @Environment(\.dismiss) private var dismiss
    @Binding var testPath: NavigationPath
    
    @State private var showStopAlert: Bool = false
    @State private var isAnswerSelected: Bool = false
    @State private var testTime: TimeInterval = 0
    @State private var testCorrectAnswers: Int = 0
    @State private var testIncorrectAnswers: Int = 0
    
    let numberOfQuestions: Int
    
    // MARK: - Initializers
    init(numberOfQuestions: Int, testPath: Binding<NavigationPath>) {
        self.numberOfQuestions = numberOfQuestions
        self._testPath = testPath
        self._viewModel = StateObject(wrappedValue: TestViewModel(context: PersistenceController.shared.container.viewContext))
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 20) { // VStack
            // MARK: - Timer
            TimerView(formattedTime: viewModel.formattedTime())
            
            // MARK: - Progress
            Text("Question \(viewModel.currentQuestionIndex + 1)/\(viewModel.testQuestions.count)")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            // MARK: - Current Question
            if let question = viewModel.getCurrentQuestion() {
                VStack(spacing: 10) { // VStack
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
                } // VStack
                
                // MARK: - Answer Options
                ForEach(viewModel.answerOptions, id: \.text) { option in // ForEach
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
                } // ForEach
            } else {
                Text("Loading question...")
                    .font(.caption)
                    .foregroundColor(.gray)
            } // if-else
            
            Spacer()
        } // VStack
        .padding(.vertical)
        .navigationTitle("Test")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar { // toolbar
            ToolbarItem(placement: .navigationBarTrailing) { // ToolbarItem
                Button(action: {
                    showStopAlert = true
                }) { // Button
                    Image(systemName: "stop.circle")
                        .foregroundColor(.red)
                } // Button
            } // ToolbarItem
        } // toolbar
        .alert("Stop Test?", isPresented: $showStopAlert) { // alert
            Button("Cancel", role: .cancel) { } // Button
            Button("Stop", role: .destructive) { // Button
                testPath.removeLast(testPath.count)
            } // Button
        } message: {
            Text("All data will be lost. Are you sure?")
        } // alert
        .onAppear {
            viewModel.startTest(numberOfQuestions: numberOfQuestions)
        }
        .onDisappear {
            if !showStopAlert {
                viewModel.stopTest()
            }
        }
    } // Body
} // CurrentTestView

// MARK: - Preview
#Preview {
    NavigationStack { // NavigationStack
        CurrentTestView(numberOfQuestions: 10, testPath: .constant(NavigationPath()))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    } // NavigationStack
} // Preview
