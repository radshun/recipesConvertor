//
//  CoreDataManager.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 17/01/2021.
//

import Foundation
import CoreData

class CoreDataManager {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RecipesConvertor")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                assertionFailure("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()

    func saveContext(completion: (() -> ())? = nil) {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                completion?()
            } catch {
                let nserror = error as NSError
                completion?()
                assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchRecipies() -> [Recipe]{
        do {
            let recipies = try context.fetch(RecipeCoreData.fetch()) as [RecipeCoreData]
            return recipies.compactMap{ $0.asRecipe() }
        }
        catch{
            print(error.localizedDescription)
            return []
        }
    }
    
    func deleteRecipe(_ recipe: Recipe, completion: @escaping () -> ()){
        guard let recipies = try? context.fetch(RecipeCoreData.fetchRequest()) as? [RecipeCoreData],
              let recipe = (recipies.first { $0.id == Int32(recipe.id) }) else { return }
        context.delete(recipe)
        saveContext {
            completion()
        }
    }
}
