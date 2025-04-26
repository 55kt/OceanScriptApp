//
//  ContentView.swift
//  OceanScript
//
//  Created by Vlad on 25/4/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: Category.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)]
    ) private var categories: FetchedResults<Category>
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(categories) { category in
                            NavigationLink(destination: QuestionsList(category: category)) {
                                CategoryItem(categoryName: category.name, categoryIcon: category.icon)
                            }
                            .foregroundColor(.primary)
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 170)
                
                Spacer()
                Text("Select a category to view questions")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding()
                Spacer()
            }
            .navigationTitle("Categories")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
