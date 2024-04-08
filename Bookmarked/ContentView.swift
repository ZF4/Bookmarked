//
//  ContentView.swift
//  Bookmarked
//
//  Created by Zachary Farmer on 10/30/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State var searchText = ""
    @State private var createNewBook = false
    @State private var sortOrder = [SortDescriptor(\BookModel.title)]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                FeatureQuote()
                BookList(searchString: searchText, sortOrder: sortOrder)
                    .searchable(text: $searchText, prompt: "Search book titles")
                Spacer()
            }
            .background(Color("backgroundColor").edgesIgnoringSafeArea(.all))
            .navigationTitle("Library")
            .navigationBarTitleTextColor(Color.primary)
            .foregroundStyle(Color.primary)
            .toolbarRole(.editor)
            .toolbar {
                
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image("lightModeLogo")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 45)
                            .foregroundStyle(Color("logoColor"))
                        
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $sortOrder) {
                            Text("Title (A-Z)")
                                .tag([SortDescriptor(\BookModel.title)])
                            
                            Text("Title (Z-A)")
                                .tag([SortDescriptor(\BookModel.title, order: .reverse)])
                        }
                    }
                    
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        createNewBook = true
                    } label: {
                        Image(systemName: "plus")
                            .imageScale(.large)
                    }
                    
                }
            }
            .sheet(isPresented: $createNewBook) {
                AddBook()
                    .presentationDetents([.medium])
            }
        }
        .tint(Color.primary)
    }
}


#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: BookModel.self, configurations: config)
        //        let example = BookModel(title: "Be Useful", author: "Arnold S.")
        return  NavigationStack {
            ContentView()
        }
        .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}
