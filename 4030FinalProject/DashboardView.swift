//
//  DashboardView.swift
//  4030FinalProject
//
//  Created by Livia Nursalim on 11/26/24.
//

import SwiftUI

struct DashboardView: View {

    @StateObject private var viewModel = iTunesViewModel()
    @EnvironmentObject var reviewManager: ReviewManager
    @State private var searchText = "" // State variable to bind the search bar input
    @Binding var isSidebarVisible: Bool // Bind to sidebar visibility state from ContentView

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Spacer()
                        .frame(height: 130)
                    
                    if searchText.isEmpty {
                        Text("Top Music Recommendations")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                            .padding(.horizontal) // Align with other content
                        
                        // Loop through genres and display songs for each genre
                        // Referenced past projects and used AI to help me debug
                        ForEach(viewModel.songsByGenre.keys.sorted(), id: \.self) { genre in
                            VStack(alignment: .leading) {
                                Text(genre)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.leading)
                                
                                // Horizontal Scrollviews for displayed the top recommended songs per genre (Accroding to the iTunes Search API)
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 15) {
                                        ForEach(viewModel.songsByGenre[genre] ?? []) { song in
                                            NavigationLink(destination: {
                                                let binding = reviewManager.binding(for: song)
                                                ReviewDetailView(review: binding)
                                            }) {
                                                VStack {
                                                    // Display album artwork
                                                    AsyncImage(url: URL(string: song.artworkUrl100)) { image in
                                                        image
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame(width: 100, height: 100)
                                                            .cornerRadius(5.0)
                                                    } placeholder: {
                                                        ProgressView()
                                                    }
                                                    // Displays song name
                                                    Text(song.trackName)
                                                        .font(.caption)
                                                        .multilineTextAlignment(.center)
                                                        .frame(width: 100)
                                                        .foregroundColor(.white)
                                                }
                                                .padding(.horizontal, 5)
                                            }
                                        } // ForEach
                                    } // HStack
                                } // ScrollView (horizontal)
                            }
                        } // Outer ForEach
                    } else {
                        // If the search bar has text, show the search results
                        Text("Search Results")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                            .padding(.horizontal)

                        ForEach(viewModel.searchResults) { song in
                            NavigationLink(destination: {
                                let binding = reviewManager.binding(for: song)
                                ReviewDetailView(review: binding)
                            }) {
                                HStack {
                                    // Display album artwork for search results
                                    AsyncImage(url: URL(string: song.artworkUrl100)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 50, height: 50)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        // Display song title and artist
                                        Text(song.trackName)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Text(song.artistName)
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                    }
                                } // HStack
                                .padding(.vertical, 5)
                            }
                        } // ForEach
                        .padding(.horizontal)
                    }
                    // Button to navigate to the ListsView view
                    NavigationLink(destination: ListsView(isSidebarVisible: $isSidebarVisible)) {
                        Text("My Reviews")
                            .position(x: 150, y: 10)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                                
                }
                .padding(.horizontal)
            }
            // Referenced from Navigations Lists projects, with customing the nav
            .navigationBarTitleDisplayMode(.inline) // Ensure inline navigation bar
            .toolbar {
                // Custom Title
                ToolbarItem(placement: .principal) {
                    Text("TunesReviews")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                }

                // Sidebar Button
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
            }
            
            .onAppear {
                viewModel.fetchAllGenres() // Fetch trending songs grouped by genre when the view appears
                
                // Figured out how to use and customize searchable attributes
                    UISearchBar.appearance().searchTextField.defaultTextAttributes = [
                        .foregroundColor: UIColor.white // Set input text color to white
                    ]
                UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(
                    string: "Search",
                    attributes: [.foregroundColor: UIColor.lightGray]
                )
                UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .white
            }
            .customBackground()
            // Figured out how to use searchable from Chapter 37 of the textbook
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .foregroundColor(.white)
            .onChange(of: searchText) { newValue in
                viewModel.searchSongs(query: newValue) // Fetch search results whenever the search text changes
            }
        }
    }
}

#Preview {
    DashboardView(isSidebarVisible: .constant(false))
        .environmentObject(ReviewManager())
}


