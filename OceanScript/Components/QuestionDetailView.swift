//
//  QuestionDetailView.swift
//  OceanScript
//
//  Created by Vlad on 26/4/25.
//

import SwiftUI
import CoreData

// MARK: - View
struct QuestionDetailView: View {
    // MARK: - Properties
    @ObservedObject var question: Question
    @StateObject private var favoritesViewModel: FavoritesViewModel
    
    // MARK: - Initializers
    /// Initializes the view with a question to display its details.
    /// - Parameter question: The question to display.
    init(question: Question) {
        self.question = question
        self._favoritesViewModel = StateObject(wrappedValue: FavoritesViewModel(context: question.managedObjectContext ?? PersistenceController.shared.container.viewContext))
    }
    
    // MARK: - Body
    var body: some View {
        VStack { // VStack
            HStack(spacing: 20) { // HStack
                Image(systemName: question.icon)
                    .accessibilityLabel("Question icon")
                
                Button { // Button
                    favoritesViewModel.toggleFavorite(for: question)
                } label: {
                    Image(systemName: question.isFavorite ? "heart.fill" : "heart")
                        .foregroundStyle(question.isFavorite ? .red : .gray)
                        .accessibilityLabel(question.isFavorite ? "Remove from favorites" : "Add to favorites")
                        .accessibilityHint("Tap to toggle favorite status")
                        .accessibilityValue(question.isFavorite ? "Favorited" : "Not favorited")
                } // Button
            } // HStack
            
            // Question name
            Text(question.name)
                .padding()
                .accessibilityLabel("Question: \(question.name)")
            
            // Correct answer
            Text(question.correctAnswer)
                .padding()
                .accessibilityLabel("Correct answer: \(question.correctAnswer)")
            
            // Question description
            Text(question.about)
                .padding()
                .accessibilityLabel("Description: \(question.about)")
        } // VStack
        .accessibilityLabel("Question detail screen")
    } // Body
} // QuestionDetailView

// MARK: - Preview
#Preview {
    QuestionDetailView(question: Question(context: PersistenceController.preview.container.viewContext))
} // Preview
