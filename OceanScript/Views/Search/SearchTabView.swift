//
//  SearchTabView.swift
//  OceanScript
//
//  Created by Vlad on 3/5/25.
//

import SwiftUI

struct SearchTabView: View {
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
    
    init() {
        self._favoritesViewModel = StateObject(wrappedValue: FavoritesViewModel(context: PersistenceController.shared.container.viewContext))
    }
    
    // Filtered questions based on search text
    private var filteredQuestions: [Question] {
        if searchText.isEmpty {
            return []
        } else {
            return questions.filter { question in
                question.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if searchText.isEmpty {
                    // Show placeholder text when search is empty
                    Spacer()
                    Text("Find Your Question")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    Spacer()
                } else {
                    // Show filtered questions when search text is not empty
                    List {
                        ForEach(filteredQuestions) { question in
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
                    }
                }
            }
            .navigationTitle("Search Questions")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search for a question")
            // Add animation to the transition between placeholder and list
            .animation(.easeInOut(duration: 0.3), value: searchText)
        }
    }
}

#Preview {
    NavigationStack {
        SearchTabView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
