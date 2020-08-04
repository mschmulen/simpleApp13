//
//  String+Image.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/1/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import UIKit

extension String {
    
    func image(size: CGSize = CGSize(width: 256, height: 256) ) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 100)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

func emojiToImage(text: String, size: CGFloat = 128) -> UIImage {
    
    let outputImageSize = CGSize.init(width: size, height: size)
    let baseSize = text.boundingRect(with: CGSize(width: size, height: size),
                                     options: .usesLineFragmentOrigin,
                                     attributes: [.font: UIFont.systemFont(ofSize: size / 2)], context: nil).size
    let fontSize = outputImageSize.width / max(baseSize.width, baseSize.height) * (outputImageSize.width / 2)
    let font = UIFont.systemFont(ofSize: fontSize)
    let textSize = text.boundingRect(with: CGSize(width: outputImageSize.width, height: outputImageSize.height),
                                     options: .usesLineFragmentOrigin,
                                     attributes: [.font: font], context: nil).size

    let style = NSMutableParagraphStyle()
    style.alignment = NSTextAlignment.center
    style.lineBreakMode = NSLineBreakMode.byClipping

    let attr : [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font : font,
        NSAttributedString.Key.paragraphStyle: style,
        NSAttributedString.Key.backgroundColor: UIColor.clear
    ]
    
    UIGraphicsBeginImageContextWithOptions(outputImageSize, false, 0)
    text.draw(in: CGRect(x: (size - textSize.width) / 2,
                         y: (size - textSize.height) / 2,
                         width: textSize.width,
                         height: textSize.height),
                         withAttributes: attr)
    let image = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
}
