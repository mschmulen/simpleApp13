//
//  CloseButtonView.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct CloseButtonView: View {
    var body: some View {
        HStack {
            AppImage(icon: .close)
            Text("Close")
        }
    }
}

struct CloseButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CloseButtonView()
            .previewLayout(PreviewLayout.sizeThatFits)
            .padding()
    }
}
