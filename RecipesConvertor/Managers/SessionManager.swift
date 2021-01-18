//
//  SessionManager.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 12/01/2021.
//

import Foundation
import CoreData

class SessionManager {
        
    static let shared: SessionManager = SessionManager()
    
    private init() {
        self.glassType = GlassSize(with: UserDefaults.standard.integer(forKey: UserDefaults.glassType))
    }
    
    var coreDataManager: CoreDataManager = CoreDataManager()
    var recipies: [Recipe] = []
    var generalDetails: GeneralDetails?
    var convertables: [Convertable]? {
        self.generalDetails?.convertables
    }
    var units: [UnitType] = UnitType.allCases
    var isConvertionEnabled: Bool?
    
    var glassType: GlassSize = .big {
        didSet {
            UserDefaults.standard.setValue(self.glassType.rawValue, forKey: UserDefaults.glassType)
        }
    }
    
    func getConvertableIfExist(_ productName: String?) -> Convertable? {
        guard let productName = productName else { return nil }
        return convertables?.first{ $0.name == productName }
    }
    
    func isConvertableExist(_ productName: String?) -> Bool {
        guard let productName = productName else { return false }
        return convertables?.contains{ $0.name == productName } ?? false
    }
}

extension SessionManager {
    func fetchRecipes(completion: @escaping ([Recipe]) -> ()) {
        self.recipies = self.coreDataManager.fetchRecipies()
        completion(self.recipies)
    }
    
    func deleteRecipe(_ recipe: Recipe, completion: (() -> ())? = nil) {
        self.coreDataManager.deleteRecipe(recipe) {
            self.recipies.removeAll{ $0.id == recipe.id }
            completion?()
        }
    }
    
    func addRecipe(_ recipe: Recipe, completion: (() -> ())? = nil) {
        self.deleteIfExist(recipe) {
            let _ = RecipeCoreData(with: recipe)
            self.recipies.append(recipe)
            self.coreDataManager.saveContext {
                completion?()
            }
        }
    }
    
    private func deleteIfExist(_ recipe: Recipe, completion: @escaping () ->()) {
        if self.recipies.contains(where: { $0.id == recipe.id }) {
            self.deleteRecipe(recipe) {
                completion()
            }
        } else {
            completion()
        }
    }
}

extension UserDefaults {
    static let glassType = "GlassType"
}
