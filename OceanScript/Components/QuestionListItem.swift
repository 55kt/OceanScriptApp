//
//  QuestionListItem.swift
//  OceanScript
//
//  Created by Vlad on 26/4/25.
//

import SwiftUI

struct QuestionListItem: View {
    var questionIcon: String
    var questionText: String
    let isFavorite: Bool
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: questionIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundStyle(.black)
            
            
            
            Text(questionText)
                .font(.title3)
                .bold()
            
            Spacer()
        }
        .padding()
        
        if isFavorite {
            Image(systemName: "heart.fill")
                .foregroundColor(.red)
                .frame(width: 20, height: 20)
                .padding(4)
        }
    }
}

#Preview {
    QuestionListItem(questionIcon: "questionmark.circle", questionText: "What is 2 + 2 ?", isFavorite: true)
}
