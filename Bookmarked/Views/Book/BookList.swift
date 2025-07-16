//
//  BookList.swift
//  Bookmarked
//
//  Created by Zachary Farmer on 10/31/23.
//

import SwiftUI
import SwiftData
import TipKit

struct BookList: View {
    @Environment(\.modelContext) var modelContext
    @Query var books: [BookModel]
    @State var isDeleting = false
    let deleteBookTipDone = DeleteBookTip()
    var body: some View {
        Group {
            if books.isEmpty {
                ContentUnavailableView("Add your first book", systemImage: "book.fill")
            } else {
                ScrollView {
                    LazyHStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 10) {
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
                                                    deleteBookTipDone.invalidate(reason: .actionPerformed)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 35)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
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

#if DEBUG
#Preview {
    let preview = Preview(BookModel.self)
    preview.addExamples(BookModel.sampleBooks)
    return NavigationStack {
        BookList(searchString: "", sortOrder: [])
    }
    .modelContainer(preview.container)
}
#endif
