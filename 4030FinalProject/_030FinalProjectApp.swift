//
//  _030FinalProjectApp.swift
//  4030FinalProject
//
//  Created by Livia Nursalim on 12/2/24.
//

import SwiftUI

@main
struct _030FinalProjectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ReviewManager()) // Add ReviewManager as an EnvironmentObject
        }
    }
}
