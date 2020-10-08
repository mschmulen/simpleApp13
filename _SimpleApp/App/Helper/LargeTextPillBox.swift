//
//  LargeTextPillBox.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/28/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct LargeTextPillBox: View {
    
    private let title: String
    
    init(
        _ title: String
    ) {
        self.title = title
    }
    
    var body: some View {
        Text(title)
            .modifier(PrimaryLargeBoldLabel(color: .white))
            .padding()
            .background(SemanticAppColor.random)
            .cornerRadius(10)
    }
}

struct LargeTextPillBox_Previews: PreviewProvider {
    
    static let deviceNames: [String] = [
        "iPhone SE",
        //"iPhone 11 Pro Max",
        "iPad Pro (11-inch)"
    ]
    
    static let dynamicTypeSizes: [ContentSizeCategory] = [
        .extraSmall,
        .large,
        .extraExtraExtraLarge
    ]
    
    /// Filter out "base" to prevent a duplicate preview.
    static let localizations = Bundle.main.localizations.map(Locale.init).filter { $0.identifier != "base" }
    
    static var previews: some View {
        Group {
            LargeTextPillBox("START THIS ACTIVITY")
                .previewLayout(PreviewLayout.sizeThatFits)
                .padding()
                .previewDisplayName("Default preview")
            
            ForEach (deviceNames, id:\.self) { deviceName in
                LargeTextPillBox("START THIS ACTIVITY")
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName)")
            }
            
            ForEach(dynamicTypeSizes, id: \.self) { sizeCategory in
                LargeTextPillBox("START THIS ACTIVITY")
                    .previewLayout(PreviewLayout.sizeThatFits)
                    .padding()
                    .environment(\.sizeCategory, sizeCategory)
                    .previewDisplayName("\(sizeCategory)")
            }
            
//            ForEach(localizations, id: \.identifier) { locale in
//                self.LargeTextPillBox("START THIS ACTIVITY")
//                    .previewLayout(PreviewLayout.sizeThatFits)
//                    .padding()
//                    .environment(\.locale, locale)
//                    .previewDisplayName(Locale.current.localizedString(forIdentifier: locale.identifier))
//            }
            
        }
    }
}
