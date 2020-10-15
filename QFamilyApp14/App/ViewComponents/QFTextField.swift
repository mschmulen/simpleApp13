//
//  QFTextField.swift
//  QFamilyApp14
//
//  Created by Matthew Schmulen on 10/15/20.
//

import SwiftUI

struct QFSimpleTextField: View {
    
    var placeholder: LocalizedStringKey = ""
    @Binding var text: String
    var borderColor: Color
    
    var body: some View {
        TextField(
            placeholder,
            text: $text
        )
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .strokeBorder(borderColor)
        )
    }
}

struct QFTextField<TopContent: View>: View {
    
    var placeholder: LocalizedStringKey = ""
    @Binding var text: String
    var appearance: Appearance = .default
    var topContent: TopContent
    
    init(
        placeholder: LocalizedStringKey = "",
        text: Binding<String>,
        appearance: Appearance = .default,
        @ViewBuilder topContent: () -> TopContent
    ) {
        self.placeholder = placeholder
        self._text = text
        self.appearance = appearance
        self.topContent = topContent()
    }
    
    enum Appearance {
        case `default`
        case error
    }
    
    var body: some View {
        VStack {
            topContent
            QFSimpleTextField(
                placeholder: placeholder,
                text: $text,
                borderColor: borderColor
            )
        }
    }
    
    var borderColor: Color {
        switch appearance {
        case .default:
            return .green
        case .error:
            return .red
        }
    }
}

//    var title: LocalizedStringKey
//      var placeholder: LocalizedStringKey = ""
//      @Binding var text: String
//      var appearance: Appearance = .default
//
//      enum Appearance {
//        case `default`
//        case error
//      }
//
//      var body: some View {
//        VStack {
//          HStack {
//            Text(title)
//              .bold()
//            Spacer()
//          }
//
//          TextField(
//            placeholder,
//            text: $text
//          )
//          .padding(.horizontal, 8)
//          .padding(.vertical, 4)
//          .background(
//            RoundedRectangle(cornerRadius: 8, style: .continuous)
//              .strokeBorder(borderColor)
//          )
//        }
//      }
//
//      var borderColor: Color {
//        switch appearance {
//        case .default:
//          return .green
//        case .error:
//          return .red
//        }
//      }

struct QFTextField_Previews: PreviewProvider {
    static var previews: some View {
        //QFTextField(title: "Title", text: .constant("yack"))
        
        Group {
            
            QFSimpleTextField(
                placeholder: "Placeholder",
                text: .constant("yack"),
                borderColor: .green
            ).padding()
                .previewLayout(.fixed(width: 400, height: 200))

            QFTextField(
                placeholder: "Placeholder",
                text: .constant("yack")
            ) {
                HStack {
                    Label("Label Title", systemImage: "star.fill")
                    Spacer()
                }
            }.padding()
            .previewLayout(.fixed(width: 400, height: 200))

        }
        
    }
}
