//
//  QuestionsListView.swift
//  OceanScript
//
//  Created by Vlad on 25/4/25.
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
                ForEach(questions.sorted(by: { $0.name < $1.name })) { question in
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
