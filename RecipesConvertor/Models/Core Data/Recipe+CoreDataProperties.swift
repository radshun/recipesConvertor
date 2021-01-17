//
//  Recipe+CoreDataProperties.swift
//  
//
//  Created by Daniel Radshun on 17/01/2021.
//
//

import Foundation
import CoreData


extension RecipeCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeCoreData> {
        return NSFetchRequest<RecipeCoreData>(entityName: "RecipeCoreData")
    }

    @NSManaged public var ingredient: Data?
    @NSManaged public var numOfOutcomes: Int32
    @NSManaged public var id: Int32
    @NSManaged public var name: String
}
