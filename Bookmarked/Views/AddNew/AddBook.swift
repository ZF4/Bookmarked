//
//  AddBook.swift
//  Bookmarked
//
//  Created by Zachary Farmer on 12/27/23.
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddBook: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @State var title: String = ""
    @State var buttonEnabled = false
    @State var author: String = ""
    @State var selectedPhotoData: UIImage?
    
    var body: some View {
        ZStack {
            Color("addBackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                VStack(alignment: .leading) {
                    HStack {
                        AddPhoto(selectedPhoto: $selectedPhotoData)
                        
                        VStack(alignment: .leading) {
                            HStack {
                                TextField("Title", text: $title)
                                    .padding()
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 30).fill(Color("backgroundColor"))
                                    .softInnerShadow(RoundedRectangle(cornerRadius: 30), darkShadow: Color.black.opacity(0.5), lightShadow: Color.black.opacity(0.2), spread: 0.05, radius: 2)
                            )
                            
                            HStack {
                                TextField("Author", text: $author)
                                    .padding()
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 30).fill(Color("backgroundColor"))
                                    .softInnerShadow(RoundedRectangle(cornerRadius: 30), darkShadow: Color.black.opacity(0.5), lightShadow: Color.black.opacity(0.2), spread: 0.05, radius: 2)
                            )
                            
                        }
                    }
                }
                .padding(.bottom)
                
                Button(action: addBook, label: {
                    Text("Save")
                        .frame(width: 200)
                        .foregroundStyle(Color("buttonTextColor"))
                })
                .buttonStyle(.borderedProminent)
                .disabled(self.title.isEmpty || self.author.isEmpty)
            }
        .navigationBarTitleDisplayMode(.inline)
        .padding()
        }
    }
    
    func addBook() {
        let newBook = BookModel(title: title, author: author, pngData: selectedPhotoData?.jpegData(compressionQuality: 1.0))
        modelContext.insert(newBook)
        dismiss()
    }
}


#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: BookModel.self, configurations: config)
        return AddBook()
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}
