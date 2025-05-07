//
//  FavoritesTabView.swift
//  OceanScript
//
//  Created by Vlad on 1/5/25.
//

import SwiftUI
import CoreData

// MARK: - View
struct FavoritesTabView: View {
    // MARK: - Properties
    @Environment(\.managedObjectContext) private var viewContext: NSManagedObjectContext
    
    @StateObject private var favoritesViewModel: FavoritesViewModel
    
    @FetchRequest(
        entity: Question.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Question.name, ascending: true)],
        predicate: NSPredicate(format: "isFavorite == %@", NSNumber(value: true))
    ) private var favoriteQuestions: FetchedResults<Question>
    
    // MARK: - Initializers
    init() {
        self._favoritesViewModel = StateObject(wrappedValue: FavoritesViewModel(context: PersistenceController.shared.container.viewContext))
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            List {
                if favoriteQuestions.isEmpty {
                    Text("No favorite questions yet")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding()
                        .accessibilityLabel("No favorite questions yet")
                } else {
                    ForEach(favoriteQuestions) { question in
                        NavigationLink(destination: QuestionDetailView(question: question)) {
                            QuestionListItem(
                                questionIcon: question.icon,
                                questionText: question.name,
                                isFavorite: false
                            )
                        } // NavigationLink
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(action: {
                                favoritesViewModel.toggleFavorite(for: question)
                            }) {
                                Image(systemName: "heart.slash.fill")
                            } // Button
                            .tint(.red)
                            .accessibilityLabel("Remove from favorites")
                        } // swipeActions
                        .accessibilityHint("View details of \(question.name)")
                    } // ForEach
                } // if-else
            } // List
            .navigationTitle(Text(LocalizedStringKey("Favorites")))
            .navigationBarTitleDisplayMode(.inline)
        } // NavigationStack
    } // Body
} // FavoritesTabView

// MARK: - Preview
#Preview {
    NavigationStack {
        FavoritesTabView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    } // NavigationStack
} // Preview
