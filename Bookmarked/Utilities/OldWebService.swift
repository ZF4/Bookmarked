//
//  WebService.swift
//  Bookmarked
//
//  Created by Zachary Farmer on 4/13/24.
//

import Foundation
import SwiftUI
import SwiftyJSON
/*
 ** Currenly not using **
 */
//class WebService {
//    func fetchBooks(bookTitle: String) async throws -> [BookModel] {
//        let key = googleBookApiKey
//        let urlString = "https://www.googleapis.com/books/v1/volumes?q=\(bookTitle)+inTitle:\(bookTitle)&key=\(key)&maxResults=6"
//        guard let url = URL(string: urlString) else {
//            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
//        }
//
//        let (data, _) = try await URLSession.shared.data(from: url)
//        let decoder = JSONDecoder()
//        let result = try decoder.decode(GoogleBooksAPIResponse.self, from: data)
//        var fetchedBooks: [BookModel] = []
//        for item in result.items {
//            let volumeInfo = item.volumeInfo
////            let imgUrl = item.volumeInfo.imageLinks?.smallThumbnail
//            var author = ""
//            for i in item.volumeInfo.authors?.first ?? "" {
//                author += "\(i)"
//            }
//            let book = BookModel(
//                title: volumeInfo.title,
//                author: author,
//                webImage: volumeInfo.imageLinks?.smallThumbnail ?? ""
//            )
//            fetchedBooks.append(book)
//        }
//        return fetchedBooks
//    }
//}
