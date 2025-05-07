//
//  QuestionsListView.swift
//  OceanScript
//
//  Created by Vlad on 25/4/25.
//

import SwiftUI
import CoreData

// MARK: - View
struct QuestionsList: View {
    // MARK: - Properties
    @Environment(\.managedObjectContext) private var viewContext
    
    let category: Category
    
    @StateObject private var favoritesViewModel: FavoritesViewModel
    
    @FetchRequest private var questions: FetchedResults<Question>
    
    @FetchRequest(
        entity: TestResult.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \TestResult.date, ascending: false)]
    ) private var testResults: FetchedResults<TestResult>
    
    // MARK: - Initializers
    /// Initializes the view with a category to display its questions.
    /// - Parameter category: The category whose questions will be displayed.
    init(category: Category) {
        self.category = category
        self._favoritesViewModel = StateObject(wrappedValue: FavoritesViewModel(context: PersistenceController.shared.container.viewContext))
        let fetchRequest = NSFetchRequest<Question>(entityName: "Question")
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Question.name, ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "category == %@", category)
        self._questions = FetchRequest(fetchRequest: fetchRequest)
    }
    
    // MARK: - Body
    var body: some View {
        List { // List
            Group {
                if !questions.isEmpty {
                    ForEach(questions, id: \.objectID) { question in // ForEach
                        NavigationLink(destination: QuestionDetailView(question: question)) { // NavigationLink
                            QuestionListItem(
                                questionIcon: question.icon,
                                questionText: question.name,
                                isFavorite: question.isFavorite
                            )
                        } // NavigationLink
                        .favoriteSwipeAction(for: question, viewModel: favoritesViewModel)
                    } // ForEach
                } else {
                    Text(LocalizedStringKey("No questions available"))
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .padding()
                        .accessibilityLabel("No questions available message")
                }
            } // Group
        } // List
        .navigationTitle(category.name)
        .navigationBarTitleDisplayMode(.inline)
        .accessibilityLabel("Questions list screen for category: \(category.name)")
    } // Body
} // QuestionsList
