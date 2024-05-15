//
//  AddQuote.swift
//  Bookmarked
//
//  Created by Zachary Farmer on 12/11/23.
//

import SwiftUI
import SwiftData
import Combine
import Neumorphic

struct AddQuote: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State var text: String = ""
    @State var pageNum: String = ""
    @State var isHighlighted: Bool = false
    var lineLimit = 3
    
    var book: BookModel
    @Binding var currentQuote: QuoteModel?
    
    var body: some View {
        ZStack {
            VStack {
                VStack(alignment: .leading) {
                    HStack {
                        TextField("###", text: $pageNum, axis: .vertical)
                            .underlineTextField()
                            .frame(width: 55)
                            .keyboardType(.numberPad)
                            .onReceive(Just(pageNum)) { _ in limitText(lineLimit)}
                        
                        Spacer()
                        
                        Image(systemName: "highlighter")
                            .foregroundStyle(Color.yellow)
                        
                        Button(action: {
                            isHighlighted.toggle()
                        }, label: {
                            Image(systemName: isHighlighted ? "checkmark.square" : "square")
                        })
                        .padding(.trailing, 4)
                    }
                    
                    HStack {
                        TextField("Quote from book...", text: $text, axis: .vertical)
                            .lineLimit(4...10)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 30).fill(Color("altBackgroundColor"))
                            .softInnerShadow(RoundedRectangle(cornerRadius: 30), darkShadow: Color.black.opacity(0.5), lightShadow: Color.black.opacity(0.2), spread: 0.05, radius: 2)
                    )
                }
                .padding()
                
                Button {
                    addQuote()
                } label: {
                    Text("Save")
                        .frame(width: 200)
                        .foregroundStyle(Color("buttonTextColor"))
                }
                .buttonStyle(.borderedProminent)
                .disabled(self.pageNum.isEmpty || self.text.isEmpty)
            }
            .onAppear {
                if let currentQuote {
                    text = currentQuote.text
                    pageNum = currentQuote.pageNum
                    isHighlighted = currentQuote.isHighlighted ?? false
                }
            }
        }
    }
    
    func addQuote() {
        if let currentQuote {
            currentQuote.text = text
            currentQuote.pageNum = pageNum
            currentQuote.isHighlighted = isHighlighted
        } else {
            let newQuote = QuoteModel(quote: text, pageNum: pageNum, isHighlighted: isHighlighted)
            book.quotes?.append(newQuote)
        }
        dismiss()
    }

    
    func limitText(_ upper: Int) {
        if pageNum.count > upper {
            pageNum = String(pageNum.prefix(upper))
        }
    }
    
}


#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: BookModel.self, configurations: config)
        let example = BookModel(title: "Be Useful", author: "Arnold S.")
        return AddQuote(book: example, currentQuote: .constant(QuoteModel(id: "0", quote: "This is quote", pageNum: "12")))
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}
