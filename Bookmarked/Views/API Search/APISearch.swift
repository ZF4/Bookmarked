//
//  APISearch.swift
//  Bookmarked
//
//  Created by Zachary Farmer on 4/14/24.
//

import SwiftUI
import SwiftData
import Foundation

struct APISearch: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentations) private var presentations
    @State private var createNewBook = false
    @State var apiBooks: [BookModel] = []
    @State var isDeleting = false
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            Group {
                if apiBooks.isEmpty && searchText.count < 3 {
                    ContentUnavailableView("Search for a book", systemImage: "magnifyingglass")
                } else {
                    VStack(alignment: .center) {
                        ScrollView {
                            LazyVStack(alignment: .center, spacing: 10) {
                                ForEach(apiBooks.chunked(into: 3), id: \.self) { chunk in
                                    LazyHStack(spacing: 30) {
                                        ForEach(chunk, id: \.self) { book in
                                            Button(action: {
                                                addBook(book: book)
                                            }, label: {
                                                BookView(book: book)
                                            })
                                        }
                                    }
                                }
                                .padding(.top)
                                .padding(.horizontal)
                            }
                            .onChange(of: searchText, initial: true) { value, oldValue in
                                Task {
                                    if !value.isEmpty && value.count > 3 {
                                        do {
//                                            let fetchedBooks = try await WebService().fetchBooks(bookTitle: value)
                                            let fetchedBooks = try await OldWebService().fetchBooks(bookTitle: value)
                                            apiBooks = fetchedBooks
                                        } catch {
                                            print("Failed to fetch books", error)
                                        }
                                    } else {
                                        apiBooks.removeAll()
                                    }
                                }
                            }
                            .padding(.bottom)
                            Button {
                                createNewBook = true
                            } label: {
                                NewBookButton()
                            }
                            Spacer()
                        }
                        .sheet(isPresented: $createNewBook) {
                            AddBook()
                                .environment(\.presentations, presentations + [$createNewBook])
                                .presentationDetents([.large])
                        }
                    }
                }
            }
            .searchable(text: $searchText)
        }
        .toolbarRole(.editor)
    }
    
    func addBook(book: BookModel) {
        let newBook = BookModel(title: book.title, author: book.author, webImage: book.webImage ?? "", imageType: .apiImage)
        modelContext.insert(newBook)
        Task { await DeleteBookTip.setDeleteBookEvent.donate() }
        dismiss()
    }
    
}

struct NewBookButton: View {
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20).fill(Color("altBackgroundColor")).softInnerShadow(RoundedRectangle(cornerRadius: 20), darkShadow:  Color.black.opacity(0.5), lightShadow: Color.black.opacity(0.3), spread: 0.1)
                
                Text("Can't find a book?")
                    .foregroundStyle(Color("textColor").opacity(0.3))
            }
        }
        .frame(width: 200, height: 50)
    }
}

#if DEBUG
#Preview {
    let preview = Preview(BookModel.self)
    preview.addExamples(BookModel.sampleBooks)
    return NavigationStack {
        APISearch(apiBooks: [BookModel(title: "Book", author: "Author")])
    }
    .modelContainer(preview.container)
}
#endif
