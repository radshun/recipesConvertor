//
//  Ingredient.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 07/01/2021.
//

import Foundation

struct Ingredient: Codable {
    var amount: Number?
    var unit: UnitType?
    var name: String?
    
    func isValid() -> Bool {
        self.amount?.isValid() ?? false && self.unit != nil && !(self.name?.isEmpty ?? true)
    }
    
    func isConvetable() -> Bool {
        guard let name = self.name, let unit = self.unit else { return false }
        return SessionManager.shared.isConvertableExist(name) && unit.isConvertable
    }
}
