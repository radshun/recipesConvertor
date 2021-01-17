//
//  Recipe+CoreDataClass.swift
//  
//
//  Created by Daniel Radshun on 17/01/2021.
//
//

import Foundation
import CoreData


public class RecipeCoreData: NSManagedObject {
    
    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    init(with recipe: Recipe) {
        let context = SessionManager.shared.coreDataManager.context
        let entityDescription = NSEntityDescription.entity(forEntityName: "RecipeCoreData", in: context)!
        super.init(entity: entityDescription, insertInto: context)
        
        self.id = Int32(recipe.id)
        self.name = recipe.name ?? ""
        self.ingredient = try? JSONEncoder().encode(recipe.ingredients)
        self.numOfOutcomes = Int32(recipe.numOfOutcomes ?? 0)
    }
    
    public class func fetch() -> NSFetchRequest<RecipeCoreData> {
        let request = NSFetchRequest<RecipeCoreData>(entityName: "RecipeCoreData")
        request.sortDescriptors = [NSSortDescriptor(key: CodingKeys.id.rawValue, ascending: true)]
        return request
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case ingredient = "ingredient"
        case numOfOutcomes = "numOfOutcomes"
    }
    
    func asRecipe() -> Recipe? {
        guard let ingredient = self.ingredient else { return nil }
        let ingredients = (try? JSONDecoder().decode([Ingredient].self, from: ingredient)) ?? []
        return Recipe(id: Int(self.id), name: self.name, ingredients: ingredients, numOfOutcomes: Int(self.numOfOutcomes))
    }
}
