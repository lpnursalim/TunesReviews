//
//  SidebarView.swift
//  4030FinalProject
//
//  Created by Livia Nursalim on 12/5/24.
//

import SwiftUI

// Used AI help me rebuild the sidebar
// the rawValue of SidebarOption cases (Home, My Reviews, and Logout) is used to display the sidebar items
enum SidebarOption: String, CaseIterable, Identifiable {
    case home = "Home"
    case myLists = "My Lists"
    case logout = "Logout"

    var id: String { self.rawValue } // makes it easy to show each option in the sidebar when iterating over the different cases
}

struct SidebarView: View {
    @Binding var selectedView: SidebarOption // Tracks the selected view
    @Binding var isLoggedIn: Bool // Tracks login state

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(SidebarOption.allCases) { option in
                Button(action: {
                    if option == .logout {
                        isLoggedIn = false // Log the user out
                    } else {
                        selectedView = option // Update the selected view
                    }
                }) {
                    Text(option.rawValue)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            selectedView == option
                                ? Color.blue.opacity(0.2) // Highlights the selected option
                                : Color.clear
                        )
                        .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .frame(maxHeight: .infinity)
    }
}



