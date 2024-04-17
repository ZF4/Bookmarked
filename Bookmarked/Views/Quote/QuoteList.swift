//
//  QuoteList.swift
//  Bookmarked
//
//  Created by Zachary Farmer on 12/11/23.
//

import SwiftUI
import SwiftData

struct QuoteList: View {
    @Environment(\.modelContext) var modelContext
    @State private var text = ""
    @State private var page = ""
    @State var selectedQuote: QuoteModel?
    @State var createNewQuote = false
    let book: BookModel
    
    var body: some View {
        let sortedQuote = book.quotes?.sorted(using: KeyPathComparator(\QuoteModel.creationDate)) ?? []
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            NavigationStack {
                Group {
                    if sortedQuote.isEmpty {
                        ContentUnavailableView("Add your first quote", systemImage: "quote.opening")
                            .background(Color("backgroundColor").ignoresSafeArea())
                    } else {
                        
                        List {
                            ForEach(sortedQuote) { quote in
                                NavigationLink {
                                    SingleQuoteView(quote: quote, book: book)
                                } label: {
                                    Button {
                                        selectedQuote = quote
                                        text = quote.text
                                        page = quote.pageNum
                                    } label: {
                                        QuotesView(quote: quote)
                                    }

                                }
                                .listRowBackground(Color("addBackgroundColor"))
                            }
                            .onDelete(perform: { indexSet in
                                withAnimation {
                                    indexSet.forEach { index in
                                        let quote = sortedQuote[index]
                                        book.quotes?.forEach { bookQuote in
                                            if quote.id == bookQuote.id {
                                                modelContext.delete(quote)
                                            }
                                        }
                                    }
                                }
                            })
                            
                        }
                        .background(Color("backgroundColor"))
                        .scrollContentBackground(.hidden)
                    }
                }
                .navigationTitle(book.title)
                .background(Color("backgroundColor"))
                .sheet(isPresented: $createNewQuote) {
                    AddQuote(book: book)
                        .presentationDetents([.medium])
                }
            }
            .toolbar {
                Button {
                    createNewQuote = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

#Preview {
    let preview = Preview(BookModel.self)
    preview.addExamples(BookModel.sampleBooks)
    return NavigationStack {
        QuoteList(book: BookModel(title: "Book", author: "Author"))
    }
    .modelContainer(preview.container)
}
