//
//  FavoritesViewModel.swift
//  OceanScript
//
//  Created by Vlad on 1/5/25.
//

import Foundation
import CoreData

// MARK: - Class
class FavoritesViewModel: ObservableObject {
    // MARK: - Properties
    private let context: NSManagedObjectContext
    private var saveTimer: Timer?
    
    // MARK: - Initializers
    /// Initializes the view model with a managed object context.
    /// - Parameter context: The Core Data managed object context to use for saving changes.
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Methods
    /// Toggles the favorite status of a given question and saves the changes with a delay.
    /// - Parameter question: The question to toggle the favorite status for.
    func toggleFavorite(for question: Question) {
        question.isFavorite.toggle()
        print("🔍 Updated favorite status for question: \(question.name) - isFavorite: \(question.isFavorite)")
        
        saveTimer?.invalidate()
        
        saveTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            Task {
                await self.saveContext()
            }
        }
    }
    
    /// Saves the managed object context asynchronously.
    private func saveContext() async {
        await context.perform {
            do {
                try self.context.save()
                print("🔍 Saved context after toggling favorite")
            } catch {
                print("💾 Error saving context after toggling favorite: \(error) 💾")
            }
        }
    }
    
    // MARK: - Lifecycle
    deinit {
        saveTimer?.invalidate()
    }
} // FavoritesViewModel
