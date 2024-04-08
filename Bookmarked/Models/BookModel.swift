//
//  BookModel.swift
//  Bookmarked
//
//  Created by Zachary Farmer on 10/30/23.
//

import Foundation
import SwiftData

@Model
class BookModel: Identifiable {
    var id: String
    var title: String
    var author: String
    
    @Attribute(.externalStorage)
    var imageData: Data? = nil
    
    @Relationship(deleteRule: .cascade)
    var quotes: [QuoteModel]?
    
    init(id: String = UUID().uuidString, title: String = "", author: String = "", pngData: Data? = nil) {
        self.id = id
        self.title = title
        self.author = author
        self.imageData = pngData
    }
}
