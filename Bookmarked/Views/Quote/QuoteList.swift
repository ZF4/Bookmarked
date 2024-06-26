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
    @State var selectedStatus: String?
    @State var createNewQuote = false
    @State var editQuote = false
    let book: BookModel
    
    var body: some View {
        let sortedQuote = book.quotes?.sorted(using: KeyPathComparator(\QuoteModel.pageNum)) ?? []
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            NavigationStack {
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        BookView(book: book, showText: false)
                        VStack(alignment: .leading) {
                            VStack(alignment: .leading) {
                                Text(book.title)
                                    .font(.system(size: 20))
                                    .lineLimit(1)
                                    .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                    .bold()
                                Text(book.author)
                                    .font(.system(size: 15))
                                    .fontWeight(.light)
                                
                            }
                            .padding(.bottom, 30)
                            
                            HStack(alignment: .top) {
                                VStack(alignment: .leading) {
                                    Rating(book: book)
                                    
                                    DropDownView(bookStatus: selectedStatus, options: ["Want to Read", "Reading", "Finished"], book: book, prompt: "Want to Read")
                                    
                                }
                            }
                            
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
                .navigationBarTitleDisplayMode(.inline)
                
                Divider().frame(height: 1)
                    .background(Color("lineColor"))
                    .padding(.horizontal, 15)
                
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
                                    QuotesView(quote: quote)
                                }
                                .contextMenu {
                                    Button("Edit") {
                                        selectedQuote = quote
                                        editQuote = true
                                    }
                                }
                                //Change this for list BG color
                                .listRowBackground(Color("backgroundColor"))
                            }
                            .onDelete(perform: { indexSet in
                                withAnimation {
                                    indexSet.forEach { index in
                                        let quote = sortedQuote[index]
                                        book.quotes?.forEach { bookQuote in
                                            if quote.id == bookQuote.id {
                                                modelContext.delete(quote)
                                                do {
                                                    try modelContext.save()
                                                } catch {
                                                    print("error")
                                                }
                                            }
                                        }
                                    }
                                }
                            })
                        }
                        .listStyle(PlainListStyle())
                        .background(Color("backgroundColor"))
                        .scrollContentBackground(.hidden)
                    }
                }
                .background(Color("backgroundColor"))
                .sheet(isPresented: $createNewQuote) {
                    AddQuote(book: book, currentQuote: .constant(nil))
                        .presentationDetents([.medium])
                }
                .sheet(isPresented: $editQuote) {
                    AddQuote(book: book, currentQuote: $selectedQuote)
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

#if DEBUG

#Preview {
    let preview = Preview(BookModel.self)
    preview.addExamples(BookModel.sampleBooks)
    return NavigationStack {
        QuoteList(book: BookModel(title: "Book", author: "Author"))
    }
    .modelContainer(preview.container)
}
#endif
