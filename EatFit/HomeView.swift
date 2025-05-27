//
//  HomeView.swift
//  EatFit
//
//  Created by Abhilash Ghogale on 27/05/25.
//

import SwiftUI

// MARK: - HomeView
/// The main home screen after splash.
struct HomeView: View {
    var body: some View {
        VStack {
            Image(systemName: "house.fill")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Welcome to EatFit!")
                .font(.title)
                .fontWeight(.semibold)
        }
        .padding()
    }
}

// MARK: - Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
} 