//
//  ActivityIndicatorView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/27/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI

struct ActivityIndicator : UIViewRepresentable {
  
    typealias UIViewType = UIActivityIndicatorView
    let style : UIActivityIndicatorView.Style
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> ActivityIndicator.UIViewType {
        return UIActivityIndicatorView(style: style)
    }
    
    func updateUIView(_ uiView: ActivityIndicator.UIViewType, context: UIViewRepresentableContext<ActivityIndicator>) {
        uiView.startAnimating()
    }
  
}

struct ActivityIndicatorView<Content> : View where Content : View {
    
    @Binding var isDisplayed : Bool
    @Binding var indicatorMessage : String
    
    var content: () -> Content
    
    var body : some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                if (!self.isDisplayed) {
                    self.content()
                } else {
                    self.content()
                        .disabled(true)
                        .blur(radius: 3)
                    
                    VStack {
                        Text(self.indicatorMessage)
                        ActivityIndicator(style: .large)
                    }
                    .frame(width: geometry.size.width/2.0, height: 200.0)
                    .background(Color.secondary.colorInvert())
                    .foregroundColor(Color.primary)
                    .cornerRadius(20)
                }
            }
        }
    }
}
