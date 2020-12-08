//
//  Animation+Custom.swift
//  QFamilyApp14
//
//  Created by Matthew Schmulen on 12/8/20.
//

import SwiftUI

struct AnimDuration {
    static let fast: Double = 0.1
    static let regular: Double = 0.3
    static let slow: Double = 0.5
}
 
extension Animation {
    static let easeInOutRegular = Self.easeInOut(duration: AnimDuration.regular)
    static let customCurve = Self.timingCurve(0, 0.8, 0.2, 1,
                                            duration: AnimDuration.slow)
    static let offsetSpring = Self.interpolatingSpring(
                                            mass: 0.05,
                                             stiffness: 4.5,
                                             damping: 0.8,
                                             initialVelocity: 5)
}
 
//struct ContentView: View {
//    @State private var moved = false
//    let buttonFont = Font.custom("Zilla Slab", size: 18).weight(.bold)
//    var body: some View {
//        Button("Tap me", action: {})
//            .font(buttonFont)
//            .offset(x: moved ? 15 : -15)
//            .animation(Animation.offsetSpring.repeatForever(autoreverses: true))
//            .onAppear {
//                moved = true
//            }
//    }
//}
