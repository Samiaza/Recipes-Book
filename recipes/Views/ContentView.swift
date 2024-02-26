//
//  ContentView.swift
//  recipes
//
//  Created by Gemma Emery on 2/7/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [],
        animation: .default
    ) private var recipes: FetchedResults<Recipe>
    
    private let client = SpoonacularClient.shared

    var body: some View {
        NavigationView {
            List {
                ForEach(recipes) { recipe in
                    NavigationLink {
                        RecipeView(id: recipe.id)
                    } label: {
                        RecipePreviewView(id: recipe.id)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                        .padding(.trailing, 5)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: addNewRecipe) {
                        Label("Get recipe", systemImage: "plus.circle")
                    }
                    .padding(.leading, 5)
                }
            }
        }
    }

    private func addNewRecipe() {
        withAnimation {
            client.getResource()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { recipes[$0] }.forEach(viewContext.delete)
            viewContext.saveContext()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.shared.viewContext)
    }
}
