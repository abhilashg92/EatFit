//
//  HistoryView.swift
//  EatFit
//
//  Created by Abhilash Ghogale on 27/05/25.
//

import SwiftUI
import UIKit

// MARK: - HistoryView
/// Displays the analysis history in a scrollable list of cards.
struct HistoryView: View {
    @ObservedObject var viewModel: HomeViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        List {
            ForEach(viewModel.history) { item in
                VStack(alignment: .leading, spacing: 8) {
                    if let data = item.imageData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 120)
                            .frame(maxWidth: .infinity)
                            .clipped()
                            .cornerRadius(10)
                    }
                    Text(item.name)
                        .font(.headline)
                    Text("🧂 Ingredients: \(item.ingredients.joined(separator: ", "))")
                    Text("🔥 Calories: \(item.calories) kcal")
                    Text("🍚 Carbohydrates: \(item.carbohydrates) g")
                    Text("🥩 Protein: \(item.protein) g")
                    Text("🧈 Fat: \(item.fat) g")
                }
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .onDelete(perform: deleteHistory)
        }
        .listStyle(.plain)
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
            }
        }
    }
    
    private func deleteHistory(at offsets: IndexSet) {
        viewModel.history.remove(atOffsets: offsets)
    }
}

// MARK: - Preview
struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(viewModel: HomeViewModel())
    }
} 