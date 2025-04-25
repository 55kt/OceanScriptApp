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
    
    @FetchRequest(
        entity: TestResult.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \TestResult.date, ascending: false)]
    ) private var testResults: FetchedResults<TestResult>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(categories) { category in
                    VStack(alignment: .leading) {
                        Text(category.name)
                            .font(.headline)
                        if let questions = category.questions?.allObjects as? [Question], !questions.isEmpty {
                            ForEach(questions) { question in
                                VStack(alignment: .leading) {
                                    Text(question.name)
                                        .font(.subheadline)
                                    Text("Correct Answer: \(question.correctAnswer)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    if let testResult = testResults.first,
                                       let questionResult = testResult.questionResults?.allObjects.first(where: { ($0 as? QuestionResult)?.question == question }) as? QuestionResult {
                                        Text("Answered Correctly: \(questionResult.isAnsweredCorrectly ? "Yes" : "No")")
                                            .font(.caption)
                                            .foregroundColor(questionResult.isAnsweredCorrectly ? .green : .red)
                                    } else {
                                        Text("Not answered yet")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding(.leading, 10)
                            }
                        } else {
                            Text("No questions available")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.leading, 10)
                        }
                    }
                }
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
