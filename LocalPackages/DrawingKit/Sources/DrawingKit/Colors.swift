//
//  Colors.swift
//  
//
//  Created by Matthew Schmulen on 8/4/20.
//

import SwiftUI

@available(iOS 13.0, *)
struct ColorPicker: View {
    @Binding var color: Color
    @Binding var colorPickerShown: Bool

    //var callback: @escaping ((Result<T,Error>) -> Void)
    
    private let colors = ColorsProvider.supportedColors()
    
    var body: some View {
        List(colors) { colorInfo in
            ColorEntry(colorInfo: colorInfo).onTapGesture {
                self.color = colorInfo.color
                self.colorPickerShown = false
            }
        }
    }
}

@available(iOS 13.0, *)
class ColorsProvider {
    
    static func supportedColors() -> [ColorInfo] {
        return [ColorInfo(id: 1, displayName: "Black", color: Color.black),
               ColorInfo(id: 2, displayName: "Blue", color: Color.blue),
               ColorInfo(id: 3, displayName: "Red", color: Color.red),
               ColorInfo(id: 4, displayName: "Green", color: Color.green),
               ColorInfo(id: 5, displayName: "Yellow", color: Color.yellow),
               ColorInfo(id: 6, displayName: "Orange", color: Color.orange),
               ColorInfo(id: 7, displayName: "Gray", color: Color.gray),
               ColorInfo(id: 8, displayName: "Purple", color: Color.purple),
               ColorInfo(id: 9, displayName: "Pink", color: Color.pink)]
    }
    
}

@available(iOS 13.0, *)
struct ColorEntry: View {
    let colorInfo: ColorInfo
    
    var body: some View {
        HStack {
            Circle()
                .fill(colorInfo.color)
                .frame(width: 40, height: 40)
                .padding(.all)
            Text(colorInfo.displayName)
        }
    }
}

// TODO: Fix Colors_preview
struct Colors_Previews: PreviewProvider {
    static var previews: some View {
        ColorPicker(
            color: .constant(Color.blue),
            colorPickerShown: .constant(true)
        )
    }
}
