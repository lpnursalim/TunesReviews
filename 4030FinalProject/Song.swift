//
//  Song.swift
//  4030FinalProject
//
//  Created by Livia Nursalim on 11/26/24.
//

import Foundation

// Refereced from previous projects (RandomTrivia APiI and Midterm)
struct Song: Identifiable, Codable {
    let id: Int
    let trackName: String
    let artistName: String
    let artworkUrl100: String
    
    enum CodingKeys: String, CodingKey {
        case id = "trackId"
        case trackName
        case artistName
        case artworkUrl100
    }
}

struct SongResponse: Codable {
    let results: [Song]
}

