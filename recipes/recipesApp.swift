//
//  recipesApp.swift
//  recipes
//
//  Created by Gemma Emery on 2/7/24.
//

import SwiftUI

@main
struct recipesApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, PersistenceController.shared.viewContext)
        }
    }
}
