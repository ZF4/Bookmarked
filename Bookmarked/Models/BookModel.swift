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
    
    enum ImageType: String, Codable {
        case apiImage
        case galleryImage
    }
    
    var id: String
    var title: String
    var author: String
    var webImage: String?
    var imageType: ImageType?
    var bookStatus: String?
    var rating: Int?
    
    
    @Attribute(.externalStorage)
    var imageData: Data? = nil
    
    @Relationship(deleteRule: .cascade)
    var quotes: [QuoteModel]?
    
    init(id: String = UUID().uuidString, title: String = "", author: String = "", pngData: Data? = nil, webImage: String? = nil, imageType: ImageType = .apiImage, bookStatus: String? = nil, rating: Int? = nil) {
        self.id = id
        self.title = title
        self.author = author
        self.imageData = pngData
        self.webImage = webImage
        self.imageType = imageType
        self.bookStatus = bookStatus
        self.rating = rating
    }
}
