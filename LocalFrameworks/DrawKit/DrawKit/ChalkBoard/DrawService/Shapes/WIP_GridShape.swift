//
//  GridShape.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct GridShape: Shape {
    
    let x: Int
    let y: Int

    func path(in rect: CGRect) -> Path {
        Path { path in
            let width = rect.width
            let height = rect.height
            
            // draw the rows
            var yStep:CGFloat = 0
            var xStep:CGFloat = 0
            for row in 0..<x  {
                yStep += 10
                xStep += 10
                path.addLines( [
                    CGPoint(x:0, y: yStep),
                    CGPoint(x: width, y: yStep)
                ])
                path.closeSubpath()
            }
            
            // draw the columns
//            for columns in 0..<y  {
//                yStep += 10
//                path.addLines( [
//                    CGPoint(x:0, y: 0),
//                    CGPoint(x: width, y: yStep)
//                ])
//                path.closeSubpath()
//            }
            
            
//            path.addLines( [
//                CGPoint(x: width * 0.4, y: height),
//                CGPoint(x: width * 0.4, y: height * 0.4),
//                CGPoint(x: width * 0.2, y: height * 0.4),
//                CGPoint(x: width * 0.5, y: height * 0.1),
//                CGPoint(x: width * 0.8, y: height * 0.4),
//                CGPoint(x: width * 0.6, y: height * 0.4),
//                CGPoint(x: width * 0.6, y: height)
//            ])
//            path.closeSubpath()
        }
    }
    
//    func path(in rect: CGRect) -> Path {
//        // ensure we have at least two corners, otherwise send back an empty path
//        guard corners >= 2 else { return Path() }
//
//        // draw from the center of our rectangle
//        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
//
//        // start from directly upwards (as opposed to down or to the right)
//        var currentAngle = -CGFloat.pi / 2
//
//        // calculate how much we need to move with each star corner
//        let angleAdjustment = .pi * 2 / CGFloat(corners * 2)
//
//        // figure out how much we need to move X/Y for the inner points of the star
//        let innerX = center.x * smoothness
//        let innerY = center.y * smoothness
//
//        // we're ready to start with our path now
//        var path = Path()
//
//        // move to our initial position
//        path.move(to: CGPoint(x: center.x * cos(currentAngle), y: center.y * sin(currentAngle)))
//
//        // track the lowest point we draw to, so we can center later
//        var bottomEdge: CGFloat = 0
//
//        // loop over all our points/inner points
//        for corner in 0..<corners * 2  {
//            // figure out the location of this point
//            let sinAngle = sin(currentAngle)
//            let cosAngle = cos(currentAngle)
//            let bottom: CGFloat
//
//            // if we're a multiple of 2 we are drawing the outer edge of the star
//            if corner.isMultiple(of: 2) {
//                // store this Y position
//                bottom = center.y * sinAngle
//
//                // …and add a line to there
//                path.addLine(to: CGPoint(x: center.x * cosAngle, y: bottom))
//            } else {
//                // we're not a multiple of 2, which means we're drawing an inner point
//
//                // store this Y position
//                bottom = innerY * sinAngle
//
//                // …and add a line to there
//                path.addLine(to: CGPoint(x: innerX * cosAngle, y: bottom))
//            }
//
//            // if this new bottom point is our lowest, stash it away for later
//            if bottom > bottomEdge {
//                bottomEdge = bottom
//            }
//
//            // move on to the next corner
//            currentAngle += angleAdjustment
//        }
//
//        // figure out how much unused space we have at the bottom of our drawing rectangle
//        let unusedSpace = (rect.height / 2 - bottomEdge) / 2
//
//        // create and apply a transform that moves our path down by that amount, centering the shape vertically
//        let transform = CGAffineTransform(translationX: center.x, y: center.y + unusedSpace)
//        return path.applying(transform)
//    }
}

struct GridShape_Previews: PreviewProvider {
    static var previews: some View {
        GridShape(x: 5, y: 5)
            .fill(Color.red)
            .frame(width: 200, height: 200)
            .background(Color.green)
    }
}

