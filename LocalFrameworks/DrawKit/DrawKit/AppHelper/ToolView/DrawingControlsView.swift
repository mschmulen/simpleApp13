//
//  DrawingControlsView.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct DrawingControlsView: View {
    
    @Binding var layer: [Scribble]
    
    private let spacing: CGFloat = 40
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: spacing) {
                    Button("Undo") {
                        if self.layer.count > 0 {
                            self.layer.removeLast()
                        }
                    }
                    Button("Clear") {
                        self.layer = [Scribble]()
                    }
                }
            }
        }
        .frame(height: 200)
//        .sheet(isPresented: $colorPickerShown, onDismiss: {
//            self.colorPickerShown = false
//        }, content: { () -> ColorPicker in
//            ColorPicker(color: self.$color, colorPickerShown: self.$colorPickerShown)
//        })
    }
}
