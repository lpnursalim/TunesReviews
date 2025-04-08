//
//  ViewExtension.swift
//  4030FinalProject
//
//  Created by Livia Nursalim on 12/6/24.
//

import Foundation
import SwiftUI

// Used AI te help me create a function to customize the background
extension View {
    func customBackground() -> some View {
        self
          // .background(Color("bgColor"))
            .background(Image("bgImage1"))
            .edgesIgnoringSafeArea(.all)
    }
}
