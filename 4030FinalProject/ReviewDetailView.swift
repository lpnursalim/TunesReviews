//
//  ReviewDetailView.swift
//  4030FinalProject
//
//  Created by Livia Nursalim on 11/26/24.
//

import SwiftUI

struct ReviewDetailView: View {
    @Binding var review: Review
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("Review for \(review.songName)")
                .font(.title)
                .bold()
                .padding()
                .foregroundColor(.white)

            // Slider for ranking
            // Rank can be up to one decimal place
            VStack {
                Text("Rank: \(Double(review.rank), specifier: "%.1f")")
                    .font(.headline)
                    .foregroundColor(.white)
                Slider(value: $review.rank, in: 1...5, step: 0.1)
                    .padding()
            }

            // TextEditor for user review
            TextEditor(text: $review.reviewText)
                .padding()
                .border(Color.gray, width: 1)
                .frame(height: 200)
            Spacer()
            
            // Save button
            Button("Save Review") {
                // Save happens automatically through the binding
                presentationMode.wrappedValue.dismiss() // Dismiss the view
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)

            Spacer()
        }
        .customBackground()
        .padding()
    }
}



