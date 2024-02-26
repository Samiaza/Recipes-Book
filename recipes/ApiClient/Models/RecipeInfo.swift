//
//  RecipeInfo.swift
//  recipes
//
//  Created by Gemma Emery on 2/8/24.
//

import Foundation
import UIKit

struct Recipes: Codable {
    let recipes: [RecipeInfo]
}

struct RecipeInfo: Codable {
    let id: Int
    let title: String
    let image: String
    let analyzedInstructions: [AnalyzedInstructionInfo]
}

struct AnalyzedInstructionInfo: Codable {
    let steps: [StepInfo]
}

struct StepInfo: Codable {
    let number: Int
    let step: String
}

extension RecipeInfo {
    func getImage() -> Data? {
        let url = URL(string: image)
        if let data = try? Data(contentsOf: url!) {
            return data
        }
        return nil
    }
}
