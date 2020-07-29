//
//  ArrowShape.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
// reference https://www.ioscreator.com/tutorials/swiftui-custom-shape-tutorial

/// ArrowShape
struct ArrowShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            let width = rect.width
            let height = rect.height
            path.addLines( [
                CGPoint(x: width * 0.4, y: height),
                CGPoint(x: width * 0.4, y: height * 0.4),
                CGPoint(x: width * 0.2, y: height * 0.4),
                CGPoint(x: width * 0.5, y: height * 0.1),
                CGPoint(x: width * 0.8, y: height * 0.4),
                CGPoint(x: width * 0.6, y: height * 0.4),
                CGPoint(x: width * 0.6, y: height)
            ])
            path.closeSubpath()
        }
    }
}

struct ArrowShape_Previews: PreviewProvider {
    static var previews: some View {
        ArrowShape()
    }
}




// Ring(progress: 0.5).foregroundColor(.red)
//struct Ring: Shape {
//
//    var progress: Double = 0.0
//    var thickness: Double = 10.0
//
//    func path(in rect: CGRect) -> Path {
//
//        let halfThickness = CGFloat(thickness / 2.0)
//        let rect = rect.insetBy(dx: halfThickness, dy: halfThickness)
//
//        return Path() {
//            $0.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
//                      radius: min(rect.width, rect.height) / 2,
//                      startAngle: Angle(degrees: -90),
//                      endAngle: Angle(degrees: -90 + 360 * progress),
//                      clockwise: false)
//        }.strokedPath(StrokeStyle(lineWidth: CGFloat(thickness), lineCap: .round))
//    }
//
//    var animatableData: Double {
//        get { progress }
//        set { progress = min(1.0, max(0, newValue)) }
//    }
//}




// usage
//SpiroSquare()
    //.stroke()
    //.frame(width: 200, height: 200)
//struct SpiroSquare: Shape {
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//
//        let rotations = 5
//        let amount = .pi / CGFloat(rotations)
//        let transform = CGAffineTransform(rotationAngle: amount)
//
//        for _ in 0 ..< rotations {
//            path = path.applying(transform)
//
//            path.addRect(CGRect(x: -rect.width / 2, y: -rect.height / 2, width: rect.width, height: rect.height))
//        }
//
//        return path
//    }
//}



