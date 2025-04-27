//
//  MainTabView.swift
//  OceanScript
//
//  Created by Vlad on 26/4/25.
//

import SwiftUI

struct MainTabView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        NavigationStack {
            TabView {
                Tab("Home", systemImage: "house") {
                    HomeView()
                }// Home
                
                Tab("Favorites", systemImage: "heart") {
                    //
                }// Favorites
            }
        }
    }
}

#Preview {
    MainTabView()
}
