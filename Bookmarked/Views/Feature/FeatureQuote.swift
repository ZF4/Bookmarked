//
//  FeatureQuote.swift
//  Bookmarked
//
//  Created by Zachary Farmer on 3/23/24.
//

import SwiftUI
import Neumorphic
import SwiftData

struct FeatureQuote: View {
    @AppStorage("bookGoalSet") var bookGoalSet: Bool = false
    @Query var books: [BookModel]
    
    var body: some View {
        Group {
            if books.isEmpty {
                NoBooks()
            } else {
                let quotesByAuthor = createQuotesByAuthorDictionary()
                let allQuotes = Array(quotesByAuthor.values.joined())
                let randomQuotes = Array(allQuotes.shuffled().prefix(3))
                
                    HStack {
                        if (allQuotes.isEmpty) {
                            NoBooks()
                        } else {
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(randomQuotes, id: \.self) { quote in
                                        if let author = quotesByAuthor.first(where: { $0.value.contains(quote) })?.key {
                                            FeaturedQuote(quoteText: quote, authorText: author)
                                        } else {

                                        }
                                    }
                                }
                            }
                            .padding(.bottom, bookGoalSet ? 0 : 10)
                            .scrollIndicators(.hidden)
                            
                        }
                    }
            }
        }
    }
    func createQuotesByAuthorDictionary() -> [String: [String]] {
        var quotesByAuthor: [String: [String]] = [:]  // Dictionary to store quotes by author
        
        for book in books {
            let author = book.author
            let quotes = book.quotes?.map { $0.text } ?? []
            
            if let existingQuotes = quotesByAuthor[author] {
                quotesByAuthor[author] = existingQuotes + quotes
            } else {
                quotesByAuthor[author] = quotes
            }
        }
        
        return quotesByAuthor
    }
}

struct NoBooks: View {
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20).fill(Color("backgroundColor")).softInnerShadow(RoundedRectangle(cornerRadius: 20), darkShadow:  Color.black.opacity(0.5), lightShadow: Color.black.opacity(0.3), spread: 0.1)
                
                Text("No quotes found")
                    .foregroundStyle(Color("textColor").opacity(0.3))
            }
        }
        .frame(width: 200, height: 50)
    }
}


struct FeaturedQuote: View {
    var quoteText: String
    var authorText: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20).fill(Color("backgroundColor")).softInnerShadow(RoundedRectangle(cornerRadius: 20), darkShadow:  Color.black.opacity(0.3), lightShadow: Color.black.opacity(0.2), spread: 0.1)
            
            
            VStack(alignment: .leading) {
                Text(quoteText)
                    .padding(.leading)
                    .padding(.top)
                    .multilineTextAlignment(.leading)
                //                Spacer()
                HStack {
                    Spacer()
                    Text("- \(authorText)")
                        .padding(.trailing)
                        .padding(.bottom)
                }
            }
        }
        .padding(.leading)
        .frame(width: 300, height: 150)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: BookModel.self, QuoteModel.self, configurations: config)
        return FeaturedQuote(quoteText: "This is a quote", authorText: "Author")
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}
