//
//  NewWebService.swift
//  Bookmarked
//
//  Created by Zachary Farmer on 5/13/24.
//

import Foundation
import SwiftyJSON

enum IDTypes {
    case editionType
    case coverID
    case isbnNum
    case lccnNum
    case oclcNum
    
    var stringValue: String {
        switch self {
        case .editionType:
            return "olid"
        case .coverID:
            return "id"
        case .isbnNum:
            return "isbn"
        case .lccnNum:
            return "lccn"
        case .oclcNum:
            return "oclc"
        }
    }
    
    var bookId: String {
        switch self {
        case .editionType:
            return "cover_edition_key"
        case .coverID:
            return "cover_i"
        case .isbnNum:
            return "isbn"
        case .lccnNum:
            return "lccn"
        case .oclcNum:
            return "oclc"
        }
    }
}

class WebService {
    func fetchBooks(bookTitle: String) async throws -> [BookModel] {
        let urlString = "https://openlibrary.org/search.json?title=\(bookTitle)&limit=9"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let json = try JSON(data: data)
        
        var fetchedBooks: [BookModel] = []
        for (_, item) in json["docs"] {
            let bookTitle = item["title"].stringValue
            let authors = item["author_name"].arrayValue.map { $0.stringValue }
            let author = authors.joined(separator: ", ")
            
            let idType: IDTypes
            switch (item["cover_edition_key"].exists(), item["cover_i"].exists()) {
            case (true, false):
                idType = .editionType
            case (false, true):
                idType = .coverID
            default:
                idType = .editionType
            }
            
            let bookId = item[idType.bookId]
            let photoUrl = "https://covers.openlibrary.org/b/\(idType.stringValue)/\(bookId)-M.jpg"
            
            let book = BookModel(
                title: bookTitle,
                author: author,
                webImage: photoUrl
                
            )
            fetchedBooks.append(book)
        }
        return fetchedBooks
    }
}
