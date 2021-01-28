//
//  RoundedRectangleButtonStyle.swift
//  QFamilyApp14
//
//  Created by Matthew Schmulen on 1/27/21.
//

import SwiftUI

// reference https://fivestars.blog/swiftui/button-styles.html

/**
 - Usage:
 
 ~~~
 // Only RoundedRectangleButtonStyle is applied
 Button("Rounded rectangle button style") {
   // button tapped
   ...
 }
 .buttonStyle(RoundedRectangleButtonStyle())
 ~~~
 */
struct RoundedRectangleButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    HStack {
      Spacer()
      configuration.label.foregroundColor(.white)
      Spacer()
    }
    .padding()
    .background(Color.blue.cornerRadius(8))
    .scaleEffect(configuration.isPressed ? 0.95 : 1)
  }
}



