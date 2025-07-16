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
    @AppStorage("libraryName") var libraryName: String = ""
    @Query var bookGoal: [BookGoalModel]
    @State var searchText = ""
    @State private var hideFeatures = false
    @State private var createNewBook = false
    @State private var showSettings = false
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
                    
                    //MARK: Removed Quotes from Homescreen
//                    if searchText.isEmpty {
//                        FeatureQuote()
//                            .padding(.horizontal)
//                    }
                    
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
                .navigationTitle(libraryName == "" ? "Library" : "\(libraryName)'s Library")
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
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            showSettings.toggle()
                        } label: {
                            Image(systemName: "text.justify")
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
                .systemTrayView($showSettings) {
                    VStack(spacing: 20) {
                        ZStack {
                            SettingsView()
                        }
                    }
                    .padding(20)
                }
                .sheet(isPresented: $createNewBook) {
                    APISearch()
                        .environment(\.presentations, presentations + [$createNewBook])
                        .presentationDetents([.medium])
                }
            }
        }
        .tint(Color.primary)
    }
}



#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: BookModel.self, BookGoalModel.self, configurations: config)
        // Insert a sample BookGoalModel
        let context = container.mainContext
        let sampleGoal = BookGoalModel(goalNumber: 10, currentNumber: 2)
        context.insert(sampleGoal)
        return NavigationStack {
            ContentView()
                .task {
                    try? Tips.resetDatastore()
                    try? Tips.configure([
                        .datastoreLocation(.applicationDefault)
                    ])
                }
        }
        .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}
