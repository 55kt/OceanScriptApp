//
//  TestViewModel.swift
//  OceanScript
//
//  Created by Vlad on 2/5/25.
//

import Foundation
import CoreData

// MARK: - Class
/// A view model managing the logic and state of a test session.
class TestViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var testQuestions: [Question] = []
    @Published var currentQuestionIndex: Int = 0
    @Published var selectedAnswer: AnswerOption?
    @Published var answerOptions: [AnswerOption] = [] // Options for the current question
    @Published var elapsedTime: TimeInterval = 0
    @Published var correctAnswers: Int = 0
    @Published var incorrectAnswers: Int = 0
    
    // MARK: - Private Properties
    private let context: NSManagedObjectContext
    private var timerTask: Task<Void, Never>?
    private var startTime: Date?
    private var testResults: [QuestionResult] = []
    
    // MARK: - Initialization
    /// Initializes the view model with a managed object context.
    /// - Parameter context: The Core Data managed object context for persisting test results.
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Public Methods
    
    /// Starts a test with the specified number of questions.
    /// - Parameter numberOfQuestions: The number of questions to include in the test.
    func startTest(numberOfQuestions: Int) {
        resetTest()
        
        // Load questions for the test
        loadRandomQuestions(numberOfQuestions: numberOfQuestions)
        
        // Update answer options for the first question
        updateAnswerOptions()
        
        // Start tracking elapsed time
        startTime = Date()
        startTimer()
    }
    
    /// Stops the test and returns its results.
    /// - Returns: A tuple containing the test duration, number of correct answers, and number of incorrect answers.
    func stopTest() -> (time: TimeInterval, correct: Int, incorrect: Int) {
        stopTimer()
        let duration = elapsedTime
        let correct = correctAnswers
        let incorrect = incorrectAnswers
        
        // Persist test results to Core Data
        Task {
            await saveTestResult(duration: duration)
        }
        
        return (duration, correct, incorrect)
    }
    
    /// Selects an answer for the current question and updates the test state.
    /// - Parameter answer: The selected answer option.
    func selectAnswer(_ answer: AnswerOption) {
        selectedAnswer = answer
        
        let currentQuestion = testQuestions[currentQuestionIndex]
        let isCorrect = answer == .correct(currentQuestion.correctAnswer)
        
        // Record the question result
        let questionResult = QuestionResult(context: context)
        questionResult.isAnsweredCorrectly = isCorrect
        questionResult.question = currentQuestion
        testResults.append(questionResult)
        
        // Update answer counters
        if isCorrect {
            correctAnswers += 1
        } else {
            incorrectAnswers += 1
        }
    }
    
    /// Moves to the next question in the test.
    /// - Returns: A boolean indicating whether there are more questions to answer.
    func moveToNextQuestion() -> Bool {
        selectedAnswer = nil
        currentQuestionIndex += 1
        
        // Update answer options for the next question
        updateAnswerOptions()
        
        // Check if there are more questions
        return currentQuestionIndex < testQuestions.count
    }
    
    /// Retrieves the current question in the test.
    /// - Returns: The current question, or nil if there are no more questions.
    func getCurrentQuestion() -> Question? {
        guard currentQuestionIndex < testQuestions.count else { return nil }
        return testQuestions[currentQuestionIndex]
    }
    
    /// Formats the elapsed time as a string in MM:SS format.
    /// - Returns: A formatted string representing the elapsed time.
    func formattedTime() -> String {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    /// Retrieves the test results for display in TestResultView.
    /// - Returns: An array of QuestionResult objects representing the test results.
    func getTestResults() -> [QuestionResult] {
        testResults
    }
    
    // MARK: - Private Methods
    
    /// Resets the test state to its initial values.
    private func resetTest() {
        testQuestions = []
        currentQuestionIndex = 0
        selectedAnswer = nil
        answerOptions = []
        elapsedTime = 0
        correctAnswers = 0
        incorrectAnswers = 0
        testResults = []
        stopTimer()
        startTime = nil
    }
    
    /// Loads a random selection of questions for the test.
    /// - Parameter numberOfQuestions: The number of questions to load.
    private func loadRandomQuestions(numberOfQuestions: Int) {
        // Fetch all categories from Core Data
        let categoryFetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        let categories: [Category]
        do {
            categories = try context.fetch(categoryFetchRequest)
        } catch {
            logError("Failed to fetch categories: \(error)")
            return
        }
        
        guard !categories.isEmpty else {
            logWarning("No categories found")
            return
        }
        
        // Collect all questions from categories
        var allQuestions: [Question] = []
        for category in categories {
            if let questions = category.questions as? Set<Question> {
                allQuestions.append(contentsOf: questions)
            }
        }
        
        // Shuffle questions and select the requested number
        allQuestions.shuffle()
        let questionsToSelect = min(numberOfQuestions, allQuestions.count)
        testQuestions = Array(allQuestions.prefix(questionsToSelect))
        
        logInfo("Loaded \(testQuestions.count) random questions for test")
    }
    
    /// Updates the answer options for the current question.
    private func updateAnswerOptions() {
        guard currentQuestionIndex < testQuestions.count else {
            answerOptions = []
            return
        }
        
        let question = testQuestions[currentQuestionIndex]
        var options: [AnswerOption] = []
        
        // Add the correct answer
        options.append(.correct(question.correctAnswer))
        
        // Add incorrect answers, with fallback if not enough are provided
        let incorrectAnswers = question.incorrectAnswers ?? []
        let firstIncorrect = incorrectAnswers.indices.contains(0) ? incorrectAnswers[0] : "Incorrect Option 1"
        let secondIncorrect = incorrectAnswers.indices.contains(1) ? incorrectAnswers[1] : "Incorrect Option 2"
        options.append(.incorrect(firstIncorrect))
        options.append(.incorrect(secondIncorrect))
        
        if incorrectAnswers.count < 2 {
            logWarning("Question '\(question.name)' has fewer than 2 incorrect answers. Using fallback options.")
        }
        
        // Shuffle answer options
        answerOptions = options.shuffled()
    }
    
    /// Saves the test result to Core Data.
    /// - Parameter duration: The duration of the test.
    private func saveTestResult(duration: TimeInterval) async {
        await context.perform {
            let testResult = TestResult(context: self.context)
            testResult.id = UUID()
            testResult.date = Date()
            testResult.totalQuestions = Int32(self.testQuestions.count)
            testResult.correctAnswers = Int32(self.correctAnswers)
            testResult.duration = self.formattedTime()
            
            // Link question results to the test result
            for questionResult in self.testResults {
                questionResult.testResult = testResult
            }
            
            do {
                try self.context.save()
                self.logInfo("Saved TestResult: totalQuestions=\(self.testQuestions.count), correctAnswers=\(self.correctAnswers), duration=\(testResult.duration)")
            } catch {
                self.logError("Failed to save test result: \(error)")
            }
        }
    }
    
    /// Starts a timer to track the elapsed time of the test.
    private func startTimer() {
        timerTask?.cancel()
        timerTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
                guard let self = self, let startTime = self.startTime else { return }
                await MainActor.run {
                    self.elapsedTime = Date().timeIntervalSince(startTime)
                }
            }
        }
    }
    
    /// Stops the timer tracking the elapsed time.
    private func stopTimer() {
        timerTask?.cancel()
        timerTask = nil
    }
    
    // MARK: - Logging Helpers
    
    /// Logs an informational message.
    /// - Parameter message: The message to log.
    private func logInfo(_ message: String) {
        #if DEBUG
        print("ℹ️ TestViewModel: \(message)")
        #endif
    }
    
    /// Logs a warning message.
    /// - Parameter message: The warning to log.
    private func logWarning(_ message: String) {
        #if DEBUG
        print("⚠️ TestViewModel: \(message)")
        #endif
    }
    
    /// Logs an error message.
    /// - Parameter message: The error message to log.
    private func logError(_ message: String) {
        #if DEBUG
        print("❌ TestViewModel: \(message)")
        #endif
    }
} // TestViewModel
