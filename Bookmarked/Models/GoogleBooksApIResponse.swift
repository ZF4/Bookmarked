//
//  GoogleBooksApIResponse.swift
//  Bookmarked
//
//  Created by Zachary Farmer on 4/13/24.
//

import Foundation

struct GoogleBooksAPIResponse: Codable {
    let items: [Item]

    struct Item: Codable {
        let volumeInfo: VolumeInfo

        struct VolumeInfo: Codable {
            let title: String
            let authors: [String]?
            let publishedDate: String?
            let description: String?
            let imageLinks: ImageLinks?
            
            struct ImageLinks: Codable {
                let smallThumbnail: String?
                let thumbnail: String?
            }
        }
    }
}
