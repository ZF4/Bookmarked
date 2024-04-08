//
//  TextAlignment.swift
//  Bookmarked
//
//  Created by Zachary Farmer on 10/30/23.
//

import Foundation
import UIKit
import SwiftUI

//For getting text justified alignment, not used right now

//    init() {
//        for familyname in UIFont.familyNames {
//            print(familyname)
//
//            for fontName in UIFont.fontNames(forFamilyName: familyname) {
//                print("-- \(fontName)")
//            }
//        }
//    }

struct LabelAlignment: UIViewRepresentable {
    var text: String
    var textAlignmentStyle : TextAlignmentStyle
    var width: CGFloat
    var fontName: String
    var fontSize: CGFloat
    var fontColor: UIColor

    func makeUIView(context: Context) -> UILabel {
        let font = UIFont(name: fontName, size: fontSize)
        let label = UILabel()
        label.textAlignment = NSTextAlignment(rawValue: textAlignmentStyle.rawValue)!
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = width
        label.font = font
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.textColor = fontColor

        return label
    }

    func updateUIView(_ uiView: UILabel, context: Context) {
        uiView.text = text
    }
}

enum TextAlignmentStyle : Int{
     case left = 0 ,center = 1 , right = 2 ,justified = 3 ,natural = 4
}
