//
//  BookList.swift
//  Bookmarked
//
//  Created by Zachary Farmer on 10/30/23.
//

import SwiftUI
import SwiftData
import Neumorphic
import WebKit

struct BookView: View {
    var book: BookModel
    var height: CGFloat = 140
    var width: CGFloat = 100
    var showText: Bool = true
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                if (book.imageData == nil) && book.webImage == nil {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20).fill(Color.Neumorphic.main).softOuterShadow()
                            .frame(width: width, height: height)
                        
                        VStack {
                            Image(systemName: "exclamationmark.magnifyingglass")
                                .font(.system(size: 30))
                                .foregroundStyle(Color.black)
                                .padding(.bottom, 2)
                            Text("No image")
                                .foregroundStyle(Color.black)
                        }
                        .frame(width: width, height: height)
                        .background(Color.white.opacity(0.9))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                } else if book.imageType == .galleryImage {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20).fill(Color.Neumorphic.main).softOuterShadow()
                            .frame(width: width, height: height)
                        
                        Image(uiImage: UIImage(loadingDataFrom: book) ?? UIImage())
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: width, height: height)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                    }
                } else if book.imageType == .apiImage {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20).fill(Color.Neumorphic.main).softOuterShadow()
                            .frame(width: width, height: height)
                        
                        AsyncImage(url: URL(string: book.webImage ?? ""), content: { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: width, height: height)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }, placeholder: {
                            ProgressView()
                        })
                        
                    }
                }
            }
            
            if showText {
                VStack(alignment: .leading) {
                    Text(book.title)
                        .fontWeight(.black)
                        .font(.system(size: 16))
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    
                    Text(book.author)
                        .font(.system(size: 15))
                        .font(.caption)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                }
                
            }
        }
        .frame(width: width)
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
