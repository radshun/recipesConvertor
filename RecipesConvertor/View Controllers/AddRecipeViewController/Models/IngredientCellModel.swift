//
//  IngredientCellModel.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 07/01/2021.
//

import Foundation

struct IngredientCellModel {
    var ingredient: Ingredient
    var currentDropDownType: IngredientDropDownType = .none
    var touchedSections: Set<IngredientDropDownType>
    
    init() {
        self.ingredient = Ingredient()
        self.currentDropDownType = .none
        self.touchedSections = []
    }
    
    init(ingredient: Ingredient, currentDropDownType: IngredientDropDownType, touchedSections: [IngredientDropDownType] = []) {
        self.ingredient = ingredient
        self.currentDropDownType = currentDropDownType
        self.touchedSections = []
    }
    
    func isValid() -> Bool {
        self.ingredient.isValid()
    }
    
    mutating func setAllTouched() {
        self.touchedSections = [.units, .amout, .none]
    }
}
