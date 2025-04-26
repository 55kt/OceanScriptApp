//
//  QuestionsListView.swift
//  OceanScript
//
//  Created by Vlad on 26/4/25.
//

import SwiftUI
import CoreData

struct QuestionsList: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    let category: Category
    
    @FetchRequest(
        entity: TestResult.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \TestResult.date, ascending: false)]
    ) private var testResults: FetchedResults<TestResult>
    
    var body: some View {
        List {
            if let questions = category.questions?.allObjects as? [Question], !questions.isEmpty {
                ForEach(questions) { question in
                    NavigationLink(destination: QuestionDetailView(question: question)) {
                        QuestionListItem(
                            questionIcon: question.icon,
                            questionText: question.name
                        )
                    }
                }
            } else {
                Text("No questions available")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding()
            }
        }
        .navigationTitle(category.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    PreviewPlaceholder.setupPreviewData(in: context)
    let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
    let categories = try! context.fetch(fetchRequest)
    let category = categories.first!
    return QuestionsList(category: category)
        .environment(\.managedObjectContext, context)
}
