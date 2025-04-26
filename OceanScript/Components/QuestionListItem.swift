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
    }
}

#Preview {
    QuestionListItem(questionIcon: "questionmark.circle", questionText: "What is 2 + 2 ?")
}
