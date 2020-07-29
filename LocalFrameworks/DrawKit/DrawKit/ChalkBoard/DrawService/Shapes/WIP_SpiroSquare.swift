//
//  yack.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct SpiroSquare: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let rotations = 5
        let amount = .pi / CGFloat(rotations)
        let transform = CGAffineTransform(rotationAngle: amount)

        for _ in 0 ..< rotations {
            path = path.applying(transform)

            path.addRect(CGRect(x: -rect.width / 2, y: -rect.height / 2, width: rect.width, height: rect.height))
        }
        return path
    }//end path
    
}

struct SpiroSquare_Previews: PreviewProvider {
    static var previews: some View {
        SpiroSquare()
            .stroke()
            //.accentColor(.blue)
            .frame(width: 100, height: 100)
            //.position(CGPoint(x: 100, y: 100))
            .previewLayout(PreviewLayout.sizeThatFits)
            .padding()
    }
}

