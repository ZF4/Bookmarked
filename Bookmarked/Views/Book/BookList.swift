//
//  BookList.swift
//  Bookmarked
//
//  Created by Zachary Farmer on 10/31/23.
//

import SwiftUI
import SwiftData

struct BookList: View {
    @Environment(\.modelContext) var modelContext
    @Query var books: [BookModel]
    @State var isDeleting = false
    var body: some View {
        NavigationStack {
            Group {
                if books.isEmpty {
                    ContentUnavailableView("Add your first book", systemImage: "book.fill")
                } else {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 10) {
                            ForEach(books.chunked(into: 3), id: \.self) { chunk in
                                LazyHStack(spacing: 30) {
                                    ForEach(chunk, id: \.self) { book in
                                        NavigationLink {
                                            QuoteList(book: book)
                                        } label: {
                                            BookView(book: book)
                                                .tint(.black)
                                        }
                                        .contextMenu {
                                            Button("Delete") {
                                                if let index = books.firstIndex(where: { $0.id == book.id}) {
                                                    modelContext.delete(books[index])
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.bottom)
                    }
                }
            }
        }
        .toolbarRole(.editor)
    }
    
    
    init(searchString: String = "", sortOrder: [SortDescriptor<BookModel>] = []) {
        _books = Query(filter: #Predicate { book in
            if searchString.isEmpty {
                true
            } else {
                book.title.localizedStandardContains(searchString)
            }
        }, sort: sortOrder)
    }
}

#Preview {
    let preview = Preview(BookModel.self)
    preview.addExamples(BookModel.sampleBooks)
    return NavigationStack {
        BookList(searchString: "", sortOrder: [])
    }
    .modelContainer(preview.container)
}
