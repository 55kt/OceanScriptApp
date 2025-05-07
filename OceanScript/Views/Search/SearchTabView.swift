//
//  SearchTabView.swift
//  OceanScript
//
//  Created by Vlad on 3/5/25.
//

import SwiftUI

// MARK: - View
struct SearchTabView: View {
    // MARK: - Properties
    @Environment(\.managedObjectContext) private var viewContext
    
    // Fetch all questions from CoreData
    @FetchRequest(
        entity: Question.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Question.name, ascending: true)]
    ) private var questions: FetchedResults<Question>
    
    // State for search text
    @State private var searchText: String = ""
    
    // State for FavoritesViewModel
    @StateObject private var favoritesViewModel: FavoritesViewModel
    
    // MARK: - Initializers
    init() {
        self._favoritesViewModel = StateObject(wrappedValue: FavoritesViewModel(context: PersistenceController.shared.container.viewContext))
    }
    
    // MARK: - Private Properties
    // Filtered questions based on search text
    private var filteredQuestions: [Question] {
        searchText.isEmpty ? [] : questions.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack { // NavigationStack
            VStack { // VStack
                // Show placeholder or list based on search text
                if searchText.isEmpty {
                    VStack { // VStack
                        Spacer()
                        Text(LocalizedStringKey("Find Your Question"))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.center)
                            .accessibilityLabel("Find your question placeholder")
                        Spacer()
                    } // VStack
                } else {
                    List { // List
                        ForEach(filteredQuestions) { question in // ForEach
                            NavigationLink(destination: QuestionDetailView(question: question)) { // NavigationLink
                                QuestionListItem(
                                    questionIcon: question.icon,
                                    questionText: question.name,
                                    isFavorite: question.isFavorite
                                )
                            } // NavigationLink
                            .favoriteSwipeAction(for: question, viewModel: favoritesViewModel)
                        } // ForEach
                    } // List
                } // if-else
            } // VStack
            .navigationTitle(Text(LocalizedStringKey("Search Questions")))
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: Text(LocalizedStringKey("Search for a question")))
            // Add animation to the transition between placeholder and list
            .animation(.easeInOut(duration: 0.3), value: searchText)
            .accessibilityLabel("Search questions screen")
        } // NavigationStack
    } // Body
} // SearchTabView

// MARK: - Preview
#Preview {
    NavigationStack { // NavigationStack
        SearchTabView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    } // NavigationStack
} // Preview
