//
//  File.swift
//  
//
//  Created by Matthew Schmulen on 8/12/20.
//

import UIKit
import SwiftUI

// https://github.com/rushairer/ScreenshotableView/blob/master/Sources/ScreenshotableView/View%2BSnapshot.swift

public extension View {
    func takeScreenshot(frame:CGRect, afterScreenUpdates: Bool) -> UIImage {
        let hosting = UIHostingController(rootView: self)
        hosting.overrideUserInterfaceStyle = UIApplication.shared.windows.first?.overrideUserInterfaceStyle ?? UIUserInterfaceStyle.unspecified
        hosting.view.frame = frame
        return hosting.view.takeScreenshot(afterScreenUpdates: afterScreenUpdates)
    }
}

public extension UIView {
    func takeScreenshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshot!
    }
    
    func takeScreenshot(afterScreenUpdates: Bool) -> UIImage {
        if !self.responds(to: #selector(drawHierarchy(in:afterScreenUpdates:))) {
            return self.takeScreenshot()
        }
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0)
        let draw = self.drawHierarchy(in: self.bounds, afterScreenUpdates: afterScreenUpdates)
        print(draw)
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshot!
    }
}


//extension View {
//    func takeScreenshot(origin: CGPoint, size: CGSize) -> UIImage? {
//        let window = UIWindow(frame: CGRect(origin: origin, size: size))
//        let hosting = UIHostingController(rootView: self)
//        hosting.view.frame = window.frame
//        window.addSubview(hosting.view)
//        window.makeKeyAndVisible()
//        return hosting.view.renderedImage
//    }
//}
//
//extension UIView {
//    var renderedImage: UIImage? {
//        let rect = self.bounds
//        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
//        if let context: CGContext = UIGraphicsGetCurrentContext() {
//            self.layer.render(in: context)
//            let capturedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//            UIGraphicsEndImageContext()
//            return capturedImage
//        }
//        return nil
//    }
//}

//extension UIView {
//
//    func image() -> UIImage {
//        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
//        let image = renderer.image { context in
//            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
//        }
//        return image
//    }
//}


public struct ScreenshotableView<Content: View>: View {
    @Binding var shotting: Bool
    var completed: (UIImage) -> Void
    let content: Content
    
    public init(shotting:Binding<Bool>, completed: @escaping (UIImage) -> Void, @ViewBuilder content: () -> Content) {
        self._shotting = shotting
        self.completed = completed
        self.content = content()
    }
    
    public var body: some View {
        
        func internalView(proxy: GeometryProxy) -> some View {
            if self.shotting {
                let frame = proxy.frame(in: .global)
                DispatchQueue.main.async {
                    let screenshot = self.content.takeScreenshot(frame: frame, afterScreenUpdates: true)
                    self.completed(screenshot)
                }
            }
            return Color.clear
        }
        
        return content.background(GeometryReader(content: internalView(proxy:)))
    }
}
