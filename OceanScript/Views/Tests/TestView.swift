//
//  TestView.swift
//  OceanScript
//
//  Created by Vlad on 2/5/25.
//

import SwiftUI

struct TestView: View {
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
            // Таймер
            TimerView(formattedTime: viewModel.formattedTime())
            
            // Прогресс
            Text("Question \(viewModel.currentQuestionIndex + 1)/\(viewModel.testQuestions.count)")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            // Текущий вопрос
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
                
                // Варианты ответа
                ForEach(viewModel.answerOptions, id: \.text) { option in
                    AnswerButtonView(
                        option: option,
                        isSelected: viewModel.selectedAnswer == option,
                        isAnswerSelected: isAnswerSelected,
                        action: {
                            viewModel.selectAnswer(option)
                            isAnswerSelected = true
                            
                            // Задержка перед переходом к следующему вопросу
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
        TestView(numberOfQuestions: 10, testPath: .constant(NavigationPath()))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
