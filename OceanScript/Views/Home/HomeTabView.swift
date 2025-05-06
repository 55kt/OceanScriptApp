//
//  HomeView.swift
//  OceanScript
//
//  Created by Vlad on 26/4/25.
//

import SwiftUI
import CoreData

// MARK: - View
struct HomeTabView: View {
    // MARK: - Properties
    @Environment(\.managedObjectContext) private var viewContext: NSManagedObjectContext
    
    @FetchRequest(
        entity: Category.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)]
    ) private var categories: FetchedResults<Category>
    
    @State private var isLoading: Bool = false
    
    // MARK: - Body
    var body: some View {
        VStack {
            if isLoading && categories.isEmpty {
                ProgressView()
                    .progressViewStyle(.circular)
                    .padding()
            } else if categories.isEmpty {
                Spacer()
                Text("No categories available")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding()
                    .accessibilityLabel("No categories available")
                Spacer()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(categories, id: \.objectID) { category in
                            NavigationLink(destination: QuestionsList(category: category)) {
                                CategoryItem(categoryName: category.name, categoryIcon: category.icon)
                            } // NavigationLink
                            .foregroundColor(.primary)
                            .accessibilityHint("Navigate to questions in \(category.name)")
                        } // ForEach
                    } // HStack
                    .padding(.horizontal)
                } // ScrollView
                .frame(height: 170)
            }
            
            Spacer()
            Text("Select a category to view questions")
                .font(.title3)
                .foregroundColor(.gray)
                .padding()
                .accessibilityLabel("Select a category to view questions")
            Spacer()
        } // VStack
        .navigationTitle(Text(LocalizedStringKey("Categories")))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            isLoading = categories.isEmpty
        }
    } // Body
} // HomeTabView

// MARK: - Preview
#Preview {
    NavigationStack {
        HomeTabView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    } // NavigationStack
} // Preview
