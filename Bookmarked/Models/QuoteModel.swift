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

    init(id: String = UUID().uuidString, quote: String = "", pageNum: String = "") {
        self.id = id
        self.text = quote
        self.pageNum = pageNum
    }
    
    var book: BookModel?
}
