//
//  QuoteModel.swift
//  Bookmarked
//
//  Created by Zachary Farmer on 2/28/24.
//

import Foundation
import SwiftData

@Model
class QuoteModel {
    var id: String
    var text: String
    var pageNum: String
    var creationDate: Date = Date.now
    var isHighlighted: Bool?
    var fontSize: CGFloat?
    var isBigFont: Bool?

    init(id: String = UUID().uuidString, quote: String = "", pageNum: String = "", isHighlighted: Bool? = false, fontSize: CGFloat? = 35, isBigFont: Bool? = true) {
        self.id = id
        self.text = quote
        self.pageNum = pageNum
        self.isHighlighted = isHighlighted
        self.fontSize = fontSize
        self.isBigFont = isBigFont
    }
    
    var book: BookModel?
}
