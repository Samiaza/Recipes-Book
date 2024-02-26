//
//  Recipe.swift
//  recipes
//
//  Created by Gemma Emery on 2/11/24.
//

import CoreData

extension Recipe {
    static func getById(id: Int64, in context: NSManagedObjectContext) -> Recipe? {
        let request = NSFetchRequest<Recipe>(entityName: "Recipe")
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "id = %@", id.description)
        let results = (try? context.fetch(request)) ?? []
        return results.first
    }
}
