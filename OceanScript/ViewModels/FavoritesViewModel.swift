//
//  FavoritesViewModel.swift
//  OceanScript
//
//  Created by Vlad on 1/5/25.
//

import Foundation
import CoreData

class FavoritesViewModel: ObservableObject {
    private let context: NSManagedObjectContext
    private var saveTimer: Timer?
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func toggleFavorite(for question: Question) {
        question.isFavorite.toggle()
        print("🔍 Updated favorite status for question: \(question.name) - isFavorite: \(question.isFavorite)")
        
        saveTimer?.invalidate()
        
        saveTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            do {
                try self.context.save()
                print("🔍 Saved context after toggling favorite")
            } catch {
                print("💾 Error saving context after toggling favorite: \(error) 💾")
            }
        }
    }
    
    deinit {
        saveTimer?.invalidate()
    }
}
