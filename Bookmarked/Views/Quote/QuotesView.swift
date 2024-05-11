//
//  AllQuotesDisplay.swift
//  Bookmarked
//
//  Created by Zachary Farmer on 10/31/23.
//

import SwiftUI
import SwiftData

struct QuotesView: View {
    var quote: QuoteModel
    var body: some View {
        ZStack {
            //Change this for list BG color
            Color("backgroundColor")
                .ignoresSafeArea()
            HStack {
                VStack(alignment: .leading) {
                    //Book page
                    Text("pg. \(quote.pageNum)")
                        .font(Font.custom("Baskerville", size: 17))
                        .foregroundStyle(Color("fontColor"))
                    Divider().frame(width: 50, height: 1)
                        .background(Color("lineColor"))
                    //Quote abriviated
                    Text(quote.text)
                        .lineLimit(1)
                        .multilineTextAlignment(.leading)
                        .font(Font.custom("Baskerville", size: 22))
                }
                //Change this for list BG color
                .listRowBackground(Color("backgroundColor"))
                Spacer()
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: BookModel.self, configurations: config)
        let example = QuoteModel(quote: "Test", pageNum: "221")
        return QuotesView(quote: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}
