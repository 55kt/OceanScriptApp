//
//  FavoritesTabView.swift
//  OceanScript
//
//  Created by Vlad on 1/5/25.
//

import SwiftUI
import CoreData

struct FavoritesTabView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @StateObject private var favoritesViewModel: FavoritesViewModel
    
    @FetchRequest(
        entity: Question.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Question.name, ascending: true)],
        predicate: NSPredicate(format: "isFavorite == %@", NSNumber(value: true))
    ) private var favoriteQuestions: FetchedResults<Question>
    
    init() {
        self._favoritesViewModel = StateObject(wrappedValue: FavoritesViewModel(context: PersistenceController.shared.container.viewContext))
    }
    
    var body: some View {
        NavigationStack {
            List {
                if favoriteQuestions.isEmpty {
                    Text("No favorite questions yet")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ForEach(favoriteQuestions) { question in
                        NavigationLink(destination: QuestionDetailView(question: question)) {
                            QuestionListItem(
                                questionIcon: question.icon,
                                questionText: question.name,
                                isFavorite: false
                            )
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(action: {
                                favoritesViewModel.toggleFavorite(for: question)
                            }) {
                                Image(systemName: "heart.slash.fill")
                                    .foregroundColor(.white)
                            }
                            .tint(.red)
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NavigationStack {
        FavoritesTabView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
