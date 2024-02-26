//
//  RecipePreviewView.swift
//  recipes
//
//  Created by Gemma Emery on 2/11/24.
//

import SwiftUI

struct RecipePreviewView: View {
    @FetchRequest(fetchRequest: Recipe.fetchRequest()) private var recipes: FetchedResults<Recipe>
    private var id: Int64
    
    init(id: Int64) {
        self.id = id
        _recipes = FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "id = %@", id.description), animation: .default)
    }
    
    var body: some View {
        let img : UIImage = UIImage(data: recipes.first?.image ?? Data()) ?? UIImage(systemName: "plus.circle")!
        let name = recipes.first?.title ?? "Data loading..."
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .stroke(lineWidth: 2)
                .foregroundColor(.blue)
            VStack {
                Image(uiImage: img)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .padding(15)
                    .shadow(color: .black, radius: 10)
                Spacer(minLength: 4)
                Text(name).padding(10).font(.caption)
            }
        }
        
    }
}

struct RecipePreviewView_Previews: PreviewProvider {
    static var previews: some View {
        RecipePreviewView(id: 10)
    }
}
