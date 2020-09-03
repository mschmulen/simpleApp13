//
//  PrimaryLabel.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 9/2/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI


/**
 Usage:
    .modifier(PrimarySmallBoldLabel(color: .black))
 
 */
struct PrimarySmallBoldLabel: ViewModifier {
    
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 15, weight: .bold, design: .rounded))
            .foregroundColor(color)
    }
}

/**
Usage:
    .modifier(PrimarySmallRegularLabel(color: .black))

*/
struct PrimarySmallRegularLabel: ViewModifier {
    
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 15, weight: .regular, design: .rounded))
            .foregroundColor(color)
    }
}





/**
Usage:
 Text("Hello")
    .modifier(PrimaryBoldLabel(color: .black))

*/
struct PrimaryBoldLabel: ViewModifier {
    
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 15, weight: .bold, design: .rounded))
            .foregroundColor(color)
//            .multilineTextAlignment(.center)
//            .lineLimit(nil)
    }
}


/**
Usage:
    .modifier(PrimaryMediumLabel(color: .black))

*/
struct PrimaryMediumLabel: ViewModifier {
    
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 15, weight: .medium, design: .rounded))
            .foregroundColor(color)
    }
}


/**
 Usage:
    .modifier(PrimaryLargeBoldLabel(color: .black))
 
 */
struct PrimaryLargeBoldLabel: ViewModifier {
    
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 27, weight: .bold, design: .rounded))
            .foregroundColor(color)
    }
}

/**
Usage:
    .modifier(PrimaryLargeRegularLabel(color: .black))

*/
struct PrimaryLargeRegularLabel: ViewModifier {
    
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 27, weight: .regular, design: .rounded))
            .foregroundColor(color)
    }
}
