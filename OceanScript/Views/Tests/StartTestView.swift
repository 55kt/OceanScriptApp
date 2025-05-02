//
//  StartTestView.swift
//  OceanScript
//
//  Created by Vlad on 2/5/25.
//

import SwiftUI

struct StartTestView: View {
    @State private var numberOfQuestions: Int = 10
    @Binding var testPath: NavigationPath
    
    private let questionCounts = [5, 10, 15, 20, 25, 30]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Start a New Test")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Select the number of questions for your test")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Picker("Number of Questions", selection: $numberOfQuestions) {
                ForEach(questionCounts, id: \.self) { count in
                    Text("\(count) questions").tag(count)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            Spacer()
            
            Button(action: {
                testPath.append(TestNavigation.test(numberOfQuestions: numberOfQuestions))
            }) {
                Text("Start Test")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
        .padding(.vertical)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        StartTestView(testPath: .constant(NavigationPath()))
    }
}
