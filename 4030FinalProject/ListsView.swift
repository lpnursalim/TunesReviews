//
//  ListsView.swift
//  4030FinalProject
//
//  Created by Livia Nursalim on 11/25/24.
//

import SwiftUI

struct ListsView: View {
    @EnvironmentObject var reviewManager: ReviewManager
    @Binding var isSidebarVisible: Bool // Tracks sidebar visibility
    @State private var sortOption: SortOption = .recentlyAdded // Tracks the selected sorting option
    @State private var isSortMenuPresented: Bool = false // Tracks whether the sort menu is shown

    var body: some View {
        NavigationView {
            ZStack {
                // Added custom background image, facy it up
                Image("bgImage1")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all) // Ensure the image fills the background
                
                // Overlays the list on top of the background
                List(sortedReviews) { review in
                    if !review.reviewText.isEmpty {
                        NavigationLink(destination: ReviewDetailView(review: binding(for: review))) {
                            VStack(alignment: .leading) {
                                // Song name
                                Text(review.songName)
                                    .font(.headline)
                                    .foregroundColor(.black)

                                // Displayed the artist and rank, allows rank to show 1 decimal place
                                Text("By \(review.artistName) • Rank: \(Double(review.rank), specifier: "%.1f")")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .listRowBackground(Color.white)
                    }
                }
                .scrollContentBackground(.hidden)
                .padding(.top, 20)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("My Reviews")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .padding(20)
                }

                // Sidebar button, tried to get it actually act like a sidebar but it's more like a manel that shows up ine middle of the screen. Functions properly tho!
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        withAnimation {
                            isSidebarVisible.toggle()
                        }
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(.white)
                    }
                }

                // Sort button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isSortMenuPresented.toggle()
                    }) {
                        Image(systemName: "arrow.up.arrow.down")
                            .foregroundColor(.white)
                    }
                }
            }
            // Figured out how to used actionSheet to display the sorting options
            .actionSheet(isPresented: $isSortMenuPresented) {
                ActionSheet(
                    title: Text("Sort Reviews"),
                    message: nil, // Optional message if needed
                    buttons: [
                        .default(Text("Rank (Lowest to Highest)")) { sortOption = .rankLowToHigh },
                        .default(Text("Rank (Highest to Lowest)")) { sortOption = .rankHighToLow },
                        .default(Text("Artist Name")) { sortOption = .artistName },
                        .default(Text("Recently Added")) { sortOption = .recentlyAdded },
                        .cancel()
                    ]
                )
            } // actionSheet
        }
    }

    // Used AI to help me implement the different sorting options, mainly with the return functions
    // basically fiugring out how to filter properly to sort to its corresponsing case
    private var sortedReviews: [Review] {
        switch sortOption {
        case .rankLowToHigh:
            return reviewManager.reviews.sorted { $0.rank < $1.rank }
        case .rankHighToLow:
            return reviewManager.reviews.sorted { $0.rank > $1.rank }
        case .artistName:
            return reviewManager.reviews.sorted { $0.artistName < $1.artistName }
        case .recentlyAdded:
            return reviewManager.reviews.reversed()
        }
    }

    // Creates a binding for a specific review
    private func binding(for review: Review) -> Binding<Review> {
        guard let index = reviewManager.reviews.firstIndex(where: { $0.id == review.id }) else {
            fatalError("Review not found")
        }
        return $reviewManager.reviews[index]
    }
}

// Initallizing the different sorting cases
enum SortOption {
    case rankLowToHigh
    case rankHighToLow
    case artistName
    case recentlyAdded
}

#Preview {
    ListsView(isSidebarVisible: .constant(false))
        .environmentObject(ReviewManager())
}
