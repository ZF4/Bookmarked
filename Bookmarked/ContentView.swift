//
//  ContentView.swift
//  Bookmarked
//
//  Created by Zachary Farmer on 10/30/23.
//

import SwiftUI
import SwiftData
import TipKit

struct ContentView: View {
    @AppStorage("bookGoalSet") var bookGoalSet: Bool = false
    @Environment(\.modelContext) var modelContext
    @Environment(\.presentations) private var presentations
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    @Query var bookGoal: [BookGoalModel]
    @State var searchText = ""
    @State private var hideFeatures = false
    @State private var createNewBook = false
    @State private var showMenu = false
    @State private var sortOrder = [SortDescriptor(\BookModel.title)]
    let deleteBookTip = DeleteBookTip()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundColor")
                    .ignoresSafeArea()
                
                VStack(alignment: .center) {
                    
                    SearchBar(searchText: $searchText)
                        .padding(.horizontal)
                    
                    if searchText.isEmpty {
                        FeatureQuote()
                            .padding(.horizontal)
                    }
                    
                    TipView(deleteBookTip)
                        .frame(width: 350)
                        .tipBackground(Color.black.opacity(0.1))
                        .tipImageSize(CGSize(width: 30, height: 30))
                    
                    if bookGoalSet && searchText.isEmpty {
                        CustomProgressBar(value: bookGoal[0].percentComplete)
                            .padding(.horizontal)
                    }
                    
                    BookList(searchString: searchText, sortOrder: sortOrder)
                    
                    Spacer()
                }
                .frame(minWidth: 425)
                .background(Color("backgroundColor").edgesIgnoringSafeArea(.all))
                .navigationTitle(showMenu ? "" : "Library")
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
                                .foregroundStyle(showMenu ? .clear : Color("logoColor"))
                        }
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            showMenu.toggle()
                        } label: {
                            if showMenu {
                                Image(systemName: "x.square.fill")
                                    .foregroundStyle(Color.black)
                            } else {
                                Image(systemName: "text.justify")
                            }
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
                    APISearch()
                        .environment(\.presentations, presentations + [$createNewBook])
                        .presentationDetents([.medium])
                }
                
                GeometryReader { _ in
                    HStack {
                        SideMenuView()
                            .offset(x: showMenu ? 0 : -UIScreen.main.bounds.width)
                            .animation(.easeInOut(duration: 0.3), value: showMenu)
                        
                        Spacer()
                    }
                }
                .background(Color.black.opacity(showMenu ? 0.5 : 0))
            }
        }
        .tint(Color.primary)
    }
}



//#Preview {
//    do {
//        let config = ModelConfiguration(isStoredInMemoryOnly: true)
//        let container = try ModelContainer(for: BookModel.self, configurations: config)
//        //        let example = BookModel(title: "Be Useful", author: "Arnold S.")
//        return  NavigationStack {
//            ContentView()
//                .task {
//                    try? Tips.resetDatastore()
//                    try? Tips.configure([
//                        .datastoreLocation(.applicationDefault)
//                    ])
//                }
//        }
//        .modelContainer(container)
//    } catch {
//        fatalError("Failed to create model container.")
//    }
//}
