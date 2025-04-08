//
//  ContentView.swift
//  4030FinalProject
//
//  Created by Livia Nursalim on 11/25/24.
//

import SwiftUI
import Foundation
import Combine

struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var isSidebarVisible: Bool = false
    @StateObject private var reviewManager = ReviewManager()
    @State private var selectedView: SidebarOption = .home // Tracks the selected sidebar option

    var body: some View {
        ZStack {
            if isLoggedIn {
                ZStack {
                    // Used AI to help me handle the different states in the sidebar
                    // Handling hte different cases and navigating them to there correct states
                    Group {
                        switch selectedView {
                        case .home:
                            DashboardView(isSidebarVisible: $isSidebarVisible)
                                .environmentObject(reviewManager)
                        case .myLists:
                            ListsView(isSidebarVisible: $isSidebarVisible)
                                .environmentObject(reviewManager)
                        case .logout:
                            Text("Logging out...")
                                .onAppear {
                                    isLoggedIn = false
                                }
                        }
                    }
                    // Overlays sidebar
                    if isSidebarVisible {
                        SidebarView(selectedView: $selectedView, isLoggedIn: $isLoggedIn)
                            .frame(maxWidth: 250)
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                            .background(Color(.systemGroupedBackground))
                           .offset(x: isSidebarVisible ? 0 : -250)
                            .animation(.easeInOut, value: isSidebarVisible)
                            .navigationViewStyle(DoubleColumnNavigationViewStyle())
                    }
                }
            } else {
                // Very simple login, la la la
                ZStack {
                    Color(red: 0.99, green: 0.99, blue: 0.99)
                        .ignoresSafeArea()

                    VStack(spacing: 60) {
                        Text("Welcome to TunesReviews")
                            .font(Font.custom("Work Sans", size: 30))
                            .bold()
                            .foregroundColor(.white)
                       
                        Image(systemName: "music.note.house.fill")
                            .foregroundColor(.white)
                            .font(Font.custom("Work Sans", size: 40))
                        
                        VStack(alignment: .leading, spacing: 20) {
                            TextField("Username", text: $username)
                                .padding()
                                .frame(height: 60)
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.black, lineWidth: 0.50)
                                )
                            SecureField("Password", text: $password)
                                .padding()
                                .frame(height: 60)
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.black, lineWidth: 0.50)
                                )
                        }
                        .padding(.horizontal)

                        Button(action: {
                            // Dummy login, just to simulate a login
                            if !username.isEmpty && !password.isEmpty {
                                isLoggedIn = true // Log the user in
                            }
                        }) {
                            Text("Login")
                                .font(Font.custom("Work Sans", size: 25).weight(.bold))
                                .foregroundColor(.white)
                                .frame(width: 380, height: 60)
                                .background(Color(red: 0, green: 0.60, blue: 1))
                                .cornerRadius(10)
                                .shadow(color: Color(red: 1, green: 1, blue: 1, opacity: 0.15), radius: 0)
                        }
                        .padding(.top, 30)
                        // Filler text, doesn't naviagte to anywhere...
                        Text("Forgot password?")
                            .font(Font.custom("Work Sans", size: 16))
                            .foregroundColor(.white)
                            .padding(.top, 10)

                        Text("Don't have an account? Sign up")
                            .font(Font.custom("Work Sans", size: 18))
                            .foregroundColor(.white)
                            .padding(.top, 10)

                        Spacer()
                    }
                    .padding(100)
                      .customBackground()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

// HANDLES API (referenced using RandomTriviaAPI and StackOverflow)
// Used AI to help add on for search queries and with debugging
class iTunesViewModel: ObservableObject {
    @Published var songsByGenre: [String: [Song]] = [:]
    @Published var searchResults: [Song] = [] // For storing search results
    private var cancellables = Set<AnyCancellable>()

    // Updated this function using AI
    // Method to search for songs based on a query
    func searchSongs(query: String) {
        guard !query.isEmpty else {
            searchResults = [] // clears results if the query is empty
            return
        }
        // Method takes a query and converts it into a format that is safe to use in a URL
        let formattedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        // Made sure the API only retrieved songs and not movies or podcasts, etc...
        let urlString = "https://itunes.apple.com/search?term=\(formattedQuery)&entity=song"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: SongResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error fetching search results: \(error)")
                }
            }, receiveValue: { [weak self] response in
                self?.searchResults = response.results
            })
            .store(in: &cancellables)
    }

    // Fetches top songs by genre
    func fetchAllGenres() {
        let genres = ["Pop", "Rock", "Jazz", "Classical", "Hip-Hop"]
        for genre in genres {
            searchSongs(byGenre: genre)
        }
    }
    
    // Searches song by genre
    private func searchSongs(byGenre genre: String) {
        // Method takes a genre and converts it into a format that is safe to use in a URL
        let formattedTerm = genre.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://itunes.apple.com/search?term=\(formattedTerm)&entity=song"
        
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: SongResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error fetching songs by genre: \(error)")
                }
            }, receiveValue: { [weak self] response in
                self?.songsByGenre[genre] = response.results
            })
            .store(in: &cancellables)
    }
}

// For the Horsizontal scrollview, displaying the top songs by genre
struct SongRow: View {
    // Represents a single song instance to display
    let song: Song
    var body: some View {
        HStack {
            // Displays the song's album artwork
            AsyncImage(url: URL(string: song.artworkUrl100)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
            } placeholder: {
                // Placeholder shown while the image is loading
                ProgressView() // Displays a spinning loader indicator
            }

            VStack(alignment: .leading) {
                Text(song.trackName)
                    .font(.headline)
                Text(song.artistName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        // Aligns the image and text horizontally within the row
    }
}

