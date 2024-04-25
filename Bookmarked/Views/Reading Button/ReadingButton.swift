////
////  ReadingButton.swift
////  Bookmarked
////
////  Created by Zachary Farmer on 4/20/24.
////
//
//import SwiftUI
//
//struct ReadingButton: View {
//    var book: BookModel
//    @State var readingStatus: BookModel.ReadingStatus? = .wantToRead
//        
//    var body: some View {
//        switch book.readingStatus {
//        case .wantToRead:
//            TextButton(text: "Want to Read", color: Color.indigo)
//        case .reading:
//            TextButton(text: "Reading", color: Color.yellow)
//        case .finished:
//            TextButton(text: "Finished", color: Color.green)
//        default:
//            TextButton(text: "Want to Read", color: Color.indigo)
//        }
//    }
//}
//
//struct TextButton: View {
//    var text: String
//    var color: Color
//    var body: some View {
//        HStack {
//            Text(text)
//            Image(systemName: "arrow.down.square.fill")
//        }
//        .foregroundStyle(Color.white)
//        .frame(width: 140, height: 30)
//        .background(color)
//        .clipShape(RoundedRectangle(cornerRadius: 5))
//    }
//}
//
//#Preview {
//    ReadingButton(book: BookModel(title: "", author: "", readingStatus: .wantToRead))
//}
