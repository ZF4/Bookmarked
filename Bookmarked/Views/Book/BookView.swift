//
//  BookList.swift
//  Bookmarked
//
//  Created by Zachary Farmer on 10/30/23.
//

import SwiftUI
import SwiftData
import Neumorphic

struct BookView: View {
    var book: BookModel
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                if book.imageData == nil {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20).fill(Color.Neumorphic.main).softOuterShadow()
                            .frame(width: 100, height: 140)
                        
                        VStack {
                            Image(systemName: "exclamationmark.magnifyingglass")
                                .font(.system(size: 30))
                                .foregroundStyle(Color.black)
                                .padding(.bottom, 2)
                            Text("No image")
                                .foregroundStyle(Color.black)
                        }
                        .frame(width: 100, height: 140)
                        .background(Color.white.opacity(0.9))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20).fill(Color.Neumorphic.main).softOuterShadow()
                            .frame(width: 100, height: 140)
                        
                        Image(uiImage: UIImage(loadingDataFrom: book) ?? UIImage())
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 140)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                    }
                }
            }
            
            VStack(alignment: .leading) {
                Text(book.title)
                    .fontWeight(.black)
                    .font(.system(size: 16))
                    .minimumScaleFactor(0.5)
                    .lineLimit(2)
                
                Text(book.author)
                    .font(.system(size: 15))
                    .font(.caption)
                    .minimumScaleFactor(0.5)
                    .lineLimit(2)
            }
        }
        .frame(width: 100)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: BookModel.self, configurations: config)
        let example = BookModel(title: "Be Useful", author: "Arnold S.")
        return BookView(book: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}
