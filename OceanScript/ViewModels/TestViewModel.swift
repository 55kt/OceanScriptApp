//
//  TestViewModel.swift
//  OceanScript
//
//  Created by Vlad on 2/5/25.
//

import Foundation
import CoreData

class TestViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var testQuestions: [Question] = []
    @Published var currentQuestionIndex: Int = 0
    @Published var selectedAnswer: AnswerOption? = nil
    @Published var answerOptions: [AnswerOption] = [] // Варианты ответа для текущего вопроса
    @Published var elapsedTime: TimeInterval = 0
    @Published var correctAnswers: Int = 0
    @Published var incorrectAnswers: Int = 0
    
    // MARK: - Private Properties
    private let context: NSManagedObjectContext
    private var timer: Timer?
    private var startTime: Date?
    private var testResults: [QuestionResult] = []
    
    // MARK: - Initialization
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Public Methods
    
    /// Запускает тест с заданным количеством вопросов
    func startTest(numberOfQuestions: Int) {
        // Очищаем предыдущее состояние
        resetTest()
        
        // Загружаем вопросы
        loadRandomQuestions(numberOfQuestions: numberOfQuestions)
        
        // Устанавливаем варианты ответа для первого вопроса
        updateAnswerOptions()
        
        // Запускаем таймер
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self, let startTime = self.startTime else { return }
            self.elapsedTime = Date().timeIntervalSince(startTime)
        }
    }
    
    /// Останавливает тест и возвращает результаты
    func stopTest() -> (time: TimeInterval, correct: Int, incorrect: Int) {
        timer?.invalidate()
        timer = nil
        let duration = elapsedTime
        let correct = correctAnswers
        let incorrect = incorrectAnswers
        
        // Сохраняем результаты в CoreData
        saveTestResult(duration: duration)
        
        return (duration, correct, incorrect)
    }
    
    /// Выбирает ответ для текущего вопроса
    func selectAnswer(_ answer: AnswerOption) {
        selectedAnswer = answer
        
        let currentQuestion = testQuestions[currentQuestionIndex]
        let isCorrect = answer == .correct(currentQuestion.correctAnswer)
        
        // Создаём QuestionResult
        let questionResult = QuestionResult(context: context)
        questionResult.isAnsweredCorrectly = isCorrect
        questionResult.question = currentQuestion
        testResults.append(questionResult)
        
        // Обновляем счётчик
        if isCorrect {
            correctAnswers += 1
        } else {
            incorrectAnswers += 1
        }
    }
    
    /// Переходит к следующему вопросу
    func moveToNextQuestion() -> Bool {
        selectedAnswer = nil
        currentQuestionIndex += 1
        
        // Обновляем варианты ответа для следующего вопроса
        updateAnswerOptions()
        
        // Проверяем, остались ли вопросы
        return currentQuestionIndex < testQuestions.count
    }
    
    /// Возвращает текущий вопрос
    func getCurrentQuestion() -> Question? {
        guard currentQuestionIndex < testQuestions.count else { return nil }
        return testQuestions[currentQuestionIndex]
    }
    
    /// Форматирует время в MM:SS
    func formattedTime() -> String {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    /// Возвращает результаты теста (для TestResultView)
    func getTestResults() -> [QuestionResult] {
        return testResults
    }
    
    // MARK: - Private Methods
    
    /// Сбрасывает состояние теста
    private func resetTest() {
        testQuestions = []
        currentQuestionIndex = 0
        selectedAnswer = nil
        answerOptions = []
        elapsedTime = 0
        correctAnswers = 0
        incorrectAnswers = 0
        testResults = []
        timer?.invalidate()
        timer = nil
        startTime = nil
    }
    
    /// Загружает случайные вопросы для теста
    private func loadRandomQuestions(numberOfQuestions: Int) {
        // Загружаем все категории
        let categoryFetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        let categories: [Category]
        do {
            categories = try context.fetch(categoryFetchRequest)
        } catch {
            print("💾 Error fetching categories: \(error) 💾")
            return
        }
        
        guard !categories.isEmpty else {
            print("🔍 No categories found")
            return
        }
        
        // Загружаем все вопросы
        var allQuestions: [Question] = []
        for category in categories {
            if let questions = category.questions as? Set<Question> {
                allQuestions.append(contentsOf: questions)
            }
        }
        
        // Перемешиваем вопросы
        allQuestions.shuffle()
        
        // Выбираем запрошенное количество вопросов (или все, если их меньше)
        let questionsToSelect = min(numberOfQuestions, allQuestions.count)
        testQuestions = Array(allQuestions.prefix(questionsToSelect))
        
        print("🔍 Loaded \(testQuestions.count) random questions for test")
    }
    
    /// Обновляет варианты ответа для текущего вопроса
    private func updateAnswerOptions() {
        guard currentQuestionIndex < testQuestions.count else {
            answerOptions = []
            return
        }
        
        let question = testQuestions[currentQuestionIndex]
        var options: [AnswerOption] = []
        
        // Добавляем правильный ответ
        options.append(.correct(question.correctAnswer))
        
        // Проверяем и добавляем неправильные ответы
        if let incorrectAnswers = question.incorrectAnswers, incorrectAnswers.count >= 2 {
            options.append(.incorrect(incorrectAnswers[0]))
            options.append(.incorrect(incorrectAnswers[1]))
        } else {
            options.append(.incorrect("Incorrect Option 1"))
            options.append(.incorrect("Incorrect Option 2"))
            print("⚠️ Warning: Question \(question.name) has fewer than 2 incorrect answers. Using fallback options.")
        }
        
        // Перемешиваем варианты ответа
        answerOptions = options.shuffled()
    }
    
    /// Сохраняет результаты теста в CoreData
    private func saveTestResult(duration: TimeInterval) {
        let testResult = TestResult(context: context)
        testResult.id = UUID()
        testResult.date = Date()
        testResult.totalQuestions = Int32(testQuestions.count)
        testResult.correctAnswers = Int32(correctAnswers)
        testResult.duration = formattedTime()
        
        // Связываем QuestionResult с TestResult
        for questionResult in testResults {
            questionResult.testResult = testResult
        }
        
        do {
            try context.save()
            print("🔍 Saved TestResult: totalQuestions=\(testQuestions.count), correctAnswers=\(correctAnswers), duration=\(testResult.duration)")
        } catch {
            print("💾 Error saving test result: \(error) 💾")
        }
    }
}
