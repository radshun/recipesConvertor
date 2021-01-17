//
//  Recipe.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 17/01/2021.
//

import Foundation

struct Recipe: Codable {
    var id: Int
    var name: String?
    var ingredients: [Ingredient]
    var numOfOutcomes: Int?
    
    init(id: Int? = nil, name: String? = nil, ingredients: [Ingredient], numOfOutcomes: Int? = nil) {
        self.id = id ?? Int(NSDate().timeIntervalSince1970)
        self.name = name
        self.ingredients = ingredients
        self.numOfOutcomes = numOfOutcomes
    }
    
    func save() {
        SessionManager.shared.addRecipe(self)
    }
}
