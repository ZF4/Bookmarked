//
//  BookSamples.swift
//  Bookmarked
//
//  Created by Zachary Farmer on 3/5/24.
//

import Foundation

extension BookModel {
    static let lastWeek = Calendar.current.date(byAdding: .day, value: -7, to: Date.now)!
    static let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date.now)!
    static var sampleBooks: [BookModel] {
        [
            BookModel(title: "Book 1", author: "Author 1"),
            BookModel(title: "Book 2", author: "Author 2")
//            BookModel(title: "Book 3", author: "Author 3"),
//            BookModel(title: "Book 4", author: "Author 4"),
        ]
    }
}

extension QuoteModel {
    static var sampleQuotes: [QuoteModel] {
        [
        QuoteModel(quote: "Quote 1", pageNum: "12"),
        QuoteModel(quote: "Quote 2", pageNum: "21"),
        QuoteModel(quote: "Quote 3", pageNum: "33"),
        QuoteModel(quote: "Quote 4", pageNum: "44"),
        QuoteModel(quote: "Quote 5", pageNum: "25"),
        ]
    }
}
