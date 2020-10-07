//
//  UIApplication+endEditing.swift
//  QFamilyApp14
//
//  Created by Matthew Schmulen on 10/7/20.
//

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//struct ExampleView:View {
//
//    @State var info: String
//
//    var body: some View {
//
//        ZStack {
//            Color.blue
//            VStack {
//                Spacer()
//                Text("New Yacht")
//                    .font(.system(size: 27, weight: .bold, design: .rounded))
//                    .foregroundColor(.white)
//                    .padding()
//                Spacer()
//                Text("Yacht info")
//                    .font(.system(size: 22, weight: .bold, design: .rounded))
//                    .foregroundColor(.white)
//                    .padding()
//
//                TextEditor(text: self.$info)
//                    .foregroundColor(.black)
//                    .frame(minHeight: CGFloat(100), maxHeight: CGFloat(100))
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding(1)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 5)
//                            .stroke(Color.white, lineWidth: 2)
//                    )
//                    .padding()
//                Spacer()
//            }
//        }.onTapGesture {
//            self.endEditing()
//        }
//    }
//
//    private func endEditing() {
//        UIApplication.shared.endEditing()
//    }
//
//}
