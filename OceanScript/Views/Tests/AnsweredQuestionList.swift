//
//  AnsweredQuestionList.swift
//  OceanScript
//
//  Created by Vlad on 3/5/25.
//

import SwiftUI

// MARK: - View
struct AnsweredQuestionList: View {
    // MARK: - Properties
    let testResults: [QuestionResult]
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var favoritesViewModel: FavoritesViewModel
    
    // Fetch questions using FetchRequest
    @FetchRequest private var questions: FetchedResults<Question>
    
    // MARK: - Initializers
    init(testResults: [QuestionResult]) {
        self.testResults = testResults
        
        // Extract question IDs from testResults
        let questionIDs = testResults.compactMap { $0.question?.id }
        let predicate = NSPredicate(format: "id IN %@", questionIDs)
        
        self._questions = FetchRequest(
            entity: Question.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Question.name, ascending: true)],
            predicate: predicate
        )
        
        self._favoritesViewModel = StateObject(wrappedValue: FavoritesViewModel(context: PersistenceController.shared.container.viewContext))
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack { // NavigationStack
            List { // List
                ForEach(testResults, id: \.self) { result in // ForEach
                    if let questionID = result.question?.id,
                       let question = questions.first(where: { $0.id == questionID }) {
                        NavigationLink(destination: QuestionDetailView(question: question)) { // NavigationLink
                            HStack { // HStack
                                QuestionListItem(
                                    questionIcon: question.icon,
                                    questionText: question.name,
                                    isFavorite: question.isFavorite
                                )
                                
                                // Indicator of correct/incorrect answer
                                Image(systemName: result.isAnsweredCorrectly ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundStyle(result.isAnsweredCorrectly ? .green : .red)
                                    .frame(width: 20, height: 20)
                                    .accessibilityLabel(result.isAnsweredCorrectly ? "Correct answer" : "Incorrect answer")
                                    .accessibilityValue(result.isAnsweredCorrectly ? "Correct" : "Incorrect")
                            } // HStack
                        } // NavigationLink
                        .favoriteSwipeAction(for: question, viewModel: favoritesViewModel)
                    }
                } // ForEach
            } // List
            .navigationTitle(Text(LocalizedStringKey("Test Questions")))
            .navigationBarTitleDisplayMode(.inline)
            .padding()
        } // NavigationStack
    } // Body
} // AnsweredQuestionList

// MARK: - Preview
#Preview {
    AnsweredQuestionList(testResults: [])
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
} // Preview
