//
//  Recipe.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 17/01/2021.
//

import UIKit

struct Recipe: Codable {
    var id: Int
    var name: String?
    var image: CodableImage?
    var ingredients: [Ingredient]
    var numOfOutcomes: Int?
    
    init(id: Int? = nil, name: String? = nil, ingredients: [Ingredient], numOfOutcomes: Int? = nil, image: UIImage? = nil) {
        self.id = id ?? Int(NSDate().timeIntervalSince1970)
        self.name = name
        self.ingredients = ingredients
        self.numOfOutcomes = numOfOutcomes
        self.image = CodableImage(image: image)
    }
    
    func save() {
        SessionManager.shared.addRecipe(self)
    }
}
