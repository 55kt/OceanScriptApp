//
//  AnsweredQuestionList.swift
//  OceanScript
//
//  Created by Vlad on 3/5/25.
//

import SwiftUI

struct AnsweredQuestionList: View {
    let testResults: [QuestionResult]
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var favoritesViewModel: FavoritesViewModel
    
    // Fetch questions using FetchRequest
    @FetchRequest private var questions: FetchedResults<Question>
    
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
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(testResults, id: \.self) { result in
                    if let questionID = result.question?.id,
                       let question = questions.first(where: { $0.id == questionID }) {
                        NavigationLink(destination: QuestionDetailView(question: question)) {
                            HStack {
                                QuestionListItem(
                                    questionIcon: question.icon,
                                    questionText: question.name,
                                    isFavorite: question.isFavorite
                                )
                                
                                // Indicator of correct/incorrect answer
                                Image(systemName: result.isAnsweredCorrectly ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(result.isAnsweredCorrectly ? .green : .red)
                                    .frame(width: 20, height: 20)
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(action: {
                                favoritesViewModel.toggleFavorite(for: question)
                            }) {
                                Image(systemName: question.isFavorite ? "heart.slash.fill" : "heart.fill")
                                    .foregroundColor(.white)
                            }
                            .tint(.red)
                        }
                    }
                }
            }
            .navigationTitle("Test Questions")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
        }
    }
}

#Preview {
    AnsweredQuestionList(testResults: [])
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
