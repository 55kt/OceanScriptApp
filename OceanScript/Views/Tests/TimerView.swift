//
//  TimerView.swift
//  OceanScript
//
//  Created by Vlad on 2/5/25.
//

import SwiftUI

struct TimerView: View {
    let formattedTime: String
    
    var body: some View {
        Text("Time: \(formattedTime)")
            .font(.title2)
            .fontWeight(.bold)
            .padding()
    }
}

#Preview {
    TimerView(formattedTime: "01:23")
}
