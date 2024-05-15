//
//  BookDisplay.swift
//  Bookmarked
//
//  Created by Zachary Farmer on 10/30/23.
//

import SwiftUI
import SwiftData

struct SingleQuoteView: View {
    var quote: QuoteModel
    var book: BookModel
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Image(.newPage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    Spacer()
                    HStack {
                        Text(book.title)
                            .font(Font.custom("Baskerville", size: 22))
                            .foregroundStyle(Color.black.opacity(0.8))
                        Divider()
                            .frame(width: 1, height: 20, alignment: .center)
                            .overlay(.black)
                        Text(quote.pageNum)
                            .font(Font.custom("Baskerville", size: 22))
                            .foregroundStyle(Color.black.opacity(0.8))
                        
                        Spacer()
                    }
                    .frame(width: 330)
                    .padding(.bottom, 30)
                    
                    VStack(alignment: .leading) {
                        LabelAlignment(text: quote.text,                             textAlignmentStyle: .justified,
                                       width: 330,
                                       fontName: "Baskerville",
                                       fontSize: 35,
                                       fontColor: UIColor(Color.black.opacity(0.8)), highlight: true)
                        .padding(.bottom, 30)
                        
                        HStack {
                            Text(book.author)
                                .font(Font.custom("BaskervilleLight", size: 22))
                                .foregroundStyle(Color.black.opacity(0.8))
                            Spacer()
                        }
                        .frame(width: 330)
                    }
                    Spacer()
                }
            }
        }
        .toolbarRole(.editor)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: BookModel.self, configurations: config)
        let quoteEx = QuoteModel(quote: "This is a quote from my favorite book. I will put many more of these quotes on this list. Enjoy for now. Thank you.", pageNum: "22")
        let bookEx = BookModel(title: "Book", author: "Author")
        return SingleQuoteView(quote: quoteEx, book: bookEx)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}
