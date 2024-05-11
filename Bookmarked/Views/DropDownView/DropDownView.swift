//
//  DropDownView.swift
//  Bookmarked
//
//  Created by Zachary Farmer on 4/23/24.
//

import SwiftUI
import SwiftData
import Foundation

struct DropDownView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var scheme
    @Query var bookGoal: [BookGoalModel]
    @State private var isExpanded = false
    @State var bookStatus: String?
    @State var options: [String]
    @State var test: Int? = 0
    let book: BookModel?
    let prompt: String
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                HStack {
                    Text(bookStatus ?? prompt)
                        .foregroundStyle(Color.black)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.subheadline)
                        .foregroundStyle(Color.gray)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .frame(height: 40)
                .background(Color.white)
                .padding(.horizontal)
                .onAppear {
                    if let book {
                        bookStatus = book.bookStatus
                    }
                }
                .onTapGesture {
                    withAnimation(.snappy) { isExpanded.toggle() }
                }
                if isExpanded {
                    VStack {
                        ForEach(options, id: \.self) { status in
                            HStack {
                                Text(status)
                                    .foregroundStyle(bookStatus == status ? Color.black : Color.gray)
                                
                                Spacer()
                                
                                if bookStatus == status {
                                    Image(systemName: "checkmark")
                                        .font(.subheadline)
                                }
                            }
                            .frame(height: 35)
                            .padding(.horizontal)
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    isExpanded.toggle()
                                    bookStatus = status
                                    saveStatus(status: bookStatus!)
                                }
                            }
                        }
                    }
                    .transition(.move(edge: .bottom))
                }
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: scheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.2), radius: 4)
            .frame(width: 160)
        }
    }
    
    func saveStatus(status: String) {
        if let book {
            book.bookStatus = status
            if status == "Finished" && bookGoal.count > 0 {
                bookGoal[0].currentNumber += 1
            }
        }
    }
}

#Preview {
    DropDownView(options: ["Want to Read", "Reading", "Finished"], test: 0, book: BookModel(title: "", author: "", bookStatus: "Want to Read"), prompt: "Select")
}
