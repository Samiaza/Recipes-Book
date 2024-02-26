//
//  SpoonacularClient.swift
//  recipes
//
//  Created by Gemma Emery on 2/8/24.
//

import Foundation
import SwiftUI

class SpoonacularClient: Client {
    static let shared = SpoonacularClient()
    
    private var viewContext = PersistenceController.shared.viewContext
    
    let apiUrl = "https://api.spoonacular.com/recipes/random"
    let apiKey: String = "f58e85857a9141e487ce676ff28b093f"
    
    func getResource() {
        let url = URL(string: apiUrl + "?number=1&apiKey=\(apiKey)")!
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: { (data, _, error) in
            if let error = error { print(error) }
            else if let data = data {
                let dataStr = String(htmlEncodedString:String(bytes: data, encoding: .utf8)!)
                    .replacingOccurrences(of: "\\n", with: "")
                    .replacingOccurrences(of: "\\t", with: "")
                    .replacingOccurrences(of: "\\(", with: "")
                    .replacingOccurrences(of: "\\)", with: "")
                    .replacingOccurrences(of: "\\'", with: "")
                    .replacingOccurrences(of: "\\&", with: "")
                    .replacingOccurrences(of: "\\%", with: "")
                print(dataStr)
                do{
                    let data = try JSONDecoder().decode(Recipes.self, from: dataStr.data(using: String.Encoding.utf8)!)
//                    print(dataStr)
                    let recipeData = data.recipes[0]

                    let recipe = Recipe(context: self.viewContext)
                    recipe.id = Int64(recipeData.id)
                    recipe.image = recipeData.getImage()
                    recipe.title = recipeData.title
                    if recipeData.analyzedInstructions.isEmpty {
                        recipe.title = "Instructions are not found -> Deleting"
                        self.viewContext.delete(recipe)
                        return
                    }
                    let stepsInfo = recipeData.analyzedInstructions[0].steps
                    
                    stepsInfo.forEach { stepInfo in
                        let step = Step(context: self.viewContext)
                        step.number = Int32(stepInfo.number)
                        step.body = stepInfo.step
                        recipe.addToSteps(step)
                    }
                }
                catch {
                    print(error)
                }
                self.viewContext.saveContext()
            }
        })
        task.resume()
    }
}

extension String {

    init(htmlEncodedString: String) {
        self.init()
        guard let encodedData = htmlEncodedString.data(using: .utf8) else {
            self = htmlEncodedString
            return
        }

        let attributedOptions: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        do {
            let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            self = attributedString.string
        }
        catch {
            print("Error: \(error)")
            self = htmlEncodedString
        }
    }
}
