//
//  echowriteApp.swift
//  echowrite
//
//  Created by Sonal on 08/04/25.
//

import SwiftUI
import SwiftData

@main
struct echowriteApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            SummaryItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    @State private var showHomeView = false

    var body: some Scene {
        WindowGroup {
            if showHomeView {
                HomeView()
            } else {
                SplashView(showHomeView: $showHomeView)
            }
        }
        .modelContainer(sharedModelContainer)
    }
}

/*
 #Preview {
     ContentView()
         .modelContainer(for: Item.self, inMemory: true)
 }
 */
