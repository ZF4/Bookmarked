//
//  BookmarkedApp.swift
//  Bookmarked
//
//  Created by Zachary Farmer on 10/30/23.
//

import SwiftUI
import SwiftData
import TipKit

@main
struct BookmarkedApp: App {
    let container: ModelContainer
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .task {
                        //Undo reset for prod
//                        try? Tips.resetDatastore()
                        try? Tips.configure([
                            .datastoreLocation(.applicationDefault)
                        ])
                    }
            }
            .modelContainer(container)
        }
    }
    init() {
        let schema = Schema([BookModel.self, BookGoalModel.self])
        let config = ModelConfiguration("MyBooks", schema: schema)
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Could not configure the container")
        }
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
