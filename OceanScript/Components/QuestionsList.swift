//
//  QuestionsListView.swift
//  OceanScript
//
//  Created by Vlad on 25/4/25.
//

import SwiftUI
import CoreData

struct QuestionsList: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    let category: Category
    
    @StateObject private var favoritesViewModel: FavoritesViewModel
    
    @FetchRequest private var questions: FetchedResults<Question>
    
    @FetchRequest(
        entity: TestResult.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \TestResult.date, ascending: false)]
    ) private var testResults: FetchedResults<TestResult>
    
    init(category: Category) {
        self.category = category
        self._favoritesViewModel = StateObject(wrappedValue: FavoritesViewModel(context: PersistenceController.shared.container.viewContext))
        self._questions = FetchRequest(
            entity: Question.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Question.name, ascending: true)],
            predicate: NSPredicate(format: "category == %@", category)
        )
    }
    
    var body: some View {
        List {
            if !questions.isEmpty {
                ForEach(questions) { question in
                    NavigationLink(destination: QuestionDetailView(question: question)) {
                        QuestionListItem(
                            questionIcon: question.icon,
                            questionText: question.name,
                            isFavorite: question.isFavorite
                        )
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
            } else {
                Text("No questions available")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding()
            }
        }
        .navigationTitle(category.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
