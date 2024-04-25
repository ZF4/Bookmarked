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
    @State private var isExpanded = false
    @State var bookStatus: String?
    @State var options: [String]
    let book: BookModel?
    let prompt: String
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                HStack {
                    Text(bookStatus ?? prompt)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.subheadline)
                        .foregroundStyle(Color.gray)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .frame(height: 40)
                .background(scheme == .dark ? Color.black : Color.white)
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
                                    .foregroundStyle(bookStatus == status ? Color.primary : Color.gray)
                                
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
            .background(scheme == .dark ? Color.black : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color.primary.opacity(0.2), radius: 4)
            .frame(width: 160)
        }
    }
    
    func saveStatus(status: String) {
        if let book {
            book.bookStatus = status
        }
    }
}

#Preview {
    DropDownView(options: ["Want to Read", "Reading", "Finished"], book: BookModel(title: "", author: "", bookStatus: "Want to Read"), prompt: "Select")
}
