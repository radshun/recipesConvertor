//
//  BaseApi.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 13/01/2021.
//

import Foundation
import FirebaseDatabase

class BaseApiReference {
    var reference: DatabaseReference!
    
    init() {
        reference = Database.database().reference()
    }
}

protocol BaseAPI: TargetType {}

public protocol TargetType {
    
    var path: String { get }
}
