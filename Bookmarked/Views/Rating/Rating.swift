//
//  Rating.swift
//  Bookmarked
//
//  Created by Zachary Farmer on 4/23/24.
//

import SwiftUI

struct Rating: View {
    @State var rating: Int?
    var maxRating = 5
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    var offColor = Color.gray
    var onColor = Color.yellow
    var book: BookModel?
    
    var body: some View {
        HStack {
            ForEach(1..<maxRating + 1, id: \.self) { number in
                Button {
                    rating = number
                    updateRating(rating: rating!)
                } label: {
                    image(for: rating ?? 0)
                        .foregroundStyle(number > rating ?? 0 ? offColor : onColor)
                }
                .onAppear {
                    if let book {
                        rating = book.rating
                    }
                }
            }
        }
    }
    
    func image(for number: Int) -> Image {
        if number > rating ?? 0 {
            offImage ?? onImage
        } else {
            onImage
        }
    }
    
    func updateRating(rating: Int) {
        if let book {
            book.rating = rating
        }
    }
}

#Preview {
    Rating(rating: 3, book: BookModel())
}
