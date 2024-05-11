//
//  BookGoalModel.swift
//  Bookmarked
//
//  Created by Zachary Farmer on 5/1/24.
//

import Foundation
import SwiftData

@Model
class BookGoalModel {
    var goalNumber: Int
    var currentNumber: Int
    
    var percentComplete: CGFloat {
        if goalNumber > 0 && currentNumber >= 0 {
            let percentage = CGFloat(currentNumber) / CGFloat(goalNumber)
            return percentage
        } else {
            return 0
        }
    }
    
    init(goalNumber: Int = 1, currentNumber: Int = 0) {
        self.goalNumber = goalNumber
        self.currentNumber = currentNumber
    }
    
    var book: BookModel?

}
