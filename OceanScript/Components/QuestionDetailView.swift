//
//  QuestionDetailView.swift
//  OceanScript
//
//  Created by Vlad on 26/4/25.
//

import SwiftUI

struct QuestionDetailView: View {
    @ObservedObject var question: Question
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Image(systemName: question.icon)
                
                Button {
                    question.isFavorite.toggle()
                    print("isFavorite: \(question.name) status is Favorite = \(question.isFavorite)")
                    if let context = question.managedObjectContext {
                        do {
                            try context.save()
                        } catch {
                            print("💾 Error saving context after toggling favorite: \(error) 💾")
                        }
                    }
                } label: {
                    Image(systemName: question.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(question.isFavorite ? .red : .gray)
                }
            }
            
            // Question name (question)
            Text(question.name)
                .padding()
            
            // Question Answer
            Text(question.correctAnswer)
                .padding()
            
            // Question Description
            Text(question.about)
                .padding()
        }
    }
}

#Preview {
    QuestionDetailView(question: Question())
}
