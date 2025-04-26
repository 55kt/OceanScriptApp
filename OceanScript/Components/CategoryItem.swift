//
//  CategoryItem.swift
//  OceanScript
//
//  Created by Vlad on 26/4/25.
//

import SwiftUI

struct CategoryItem: View {
    var categoryName: String
    var categoryIcon: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
                .shadow(radius: 5)
                .frame(width: 150, height: 150)
            
            VStack {
                Image(systemName: categoryIcon)
                    .foregroundStyle(.black)
                
                
                Text(categoryName)
                    .font(.headline)
            }
        }
    }
}

#Preview {
    CategoryItem(categoryName: "Basics", categoryIcon: "book.fill")
}
