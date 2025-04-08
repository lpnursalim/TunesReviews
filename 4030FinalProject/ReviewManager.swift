//
//  ReviewManager.swift
//  4030FinalProject
//
//  Created by Livia Nursalim on 11/25/24.
//

import SwiftUI
import Foundation

struct Review: Identifiable {
    let id = UUID()
    let songName: String
    let artistName: String
    var reviewText: String
    var rank: Double = 1.0 // Making sure the min rank that can me given is 1
}

class ReviewManager: ObservableObject {
    @Published var reviews: [Review] = []
    
    init() {
        // Some dummy reviews
        reviews = [
            Review(
                songName: "Weird Fishes",
                artistName: "Radiohead",
                reviewText: "BEST SONG EVER",
                rank: 5.0
            ),
            Review(
                songName: "Bohemian Rhapsody",
                artistName: "Queen",
                reviewText: "A timeless classic!",
                rank: 4.5
            ),
            Review(
                songName: "Lose Yourself",
                artistName: "Eminem",
                reviewText: "An incredible and motivational masterpiece. Mom's spaghetti!!",
                rank: 4.0
            ),
            Review(
                songName: "Look On Down from the Bridge",
                artistName: "Mazzy Star",
                reviewText: "Nice and sad",
                rank: 3.8
            )
        ]
    }

    
    // PLEASE WORK
    // Chapter 37, stack overflow and AI to help me with binding function
    func binding(for song: Song) -> Binding<Review> {
        // checks if a review alr exists for the song
        if let index = reviews.firstIndex(where: { $0.songName == song.trackName }) {
            // if a review already exists, return a binding to it
            return Binding(
                get: { self.reviews[index] },
                set: { newValue in self.reviews[index] = newValue }
            )
        } else {
            // if no review exists, add a new one and return a binding to it
            let newReview = Review(songName: song.trackName, artistName: song.artistName, reviewText: "")
            
            // adds the new review to review array
            reviews.append(newReview)
            if let index = reviews.firstIndex(where: { $0.id == newReview.id }) {
                return Binding(
                    get: { self.reviews[index] },
                    set: { newValue in self.reviews[index] = newValue }
                )
            } else {
                fatalError("Failed to create binding for the new review")
            }
        }
    } // binding
}



