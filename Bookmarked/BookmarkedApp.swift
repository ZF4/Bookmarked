//
//  BookmarkedApp.swift
//  Bookmarked
//
//  Created by Zachary Farmer on 10/30/23.
//

import SwiftUI
import SwiftData

@main
struct BookmarkedApp: App {
    let container: ModelContainer
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
            .modelContainer(container)
        }
    }
    init() {
        let schema = Schema([BookModel.self])
        let config = ModelConfiguration("MyBooks", schema: schema)
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Could not configure the container")
        }
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
