//
//  OpenBooksAPIResponse.swift
//  Bookmarked
//
//  Created by Zachary Farmer on 5/13/24.
//

import Foundation

struct APIModel: Codable {
    let docs: [Item]
    
    struct Item: Codable {
        let title: String
        let authorName: [String]
        let coverPhoto: String?
        let coverId: String?
        
        enum CodingKeys: String, CodingKey {
            case coverPhoto = "cover_edition_key"
            case authorName = "author_name"
            case coverId = "cover_i"
            case title
        }
    }
}
