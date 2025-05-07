//
//  View+FavoriteSwipeAction.swift
//  OceanScript
//
//  Created by Vlad on 7/5/25.
//

import SwiftUI

extension View {
    func favoriteSwipeAction(for question: Question, viewModel: FavoritesViewModel) -> some View {
        self.swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(action: {
                viewModel.toggleFavorite(for: question)
            }) { // Button
                Image(systemName: question.isFavorite ? "heart.slash.fill" : "heart.fill")
                    .foregroundStyle(.white)
            } // Button
            .tint(.red)
            .accessibilityLabel(question.isFavorite ? "Remove from favorites" : "Add to favorites")
        }
    }
}
