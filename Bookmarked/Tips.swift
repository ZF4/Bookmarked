//
//  Tips.swift
//  Bookmarked
//
//  Created by Zachary Farmer on 4/17/24.
//

import Foundation
import TipKit

struct DeleteBookTip: Tip {
    static let setDeleteBookEvent = Event(id: "deleteBook")
    
    var title: Text {
        Text("Delete A Book")
    }
    
    var message: Text? {
        Text("Press and hold on a book to delete it")
    }
    
    var image: Image? {
        Image(systemName: "trash")
    }
    
    var rules: [Rule] {
        #Rule(Self.setDeleteBookEvent) { event in
            event.donations.count == 1
        }
    }
    
}
