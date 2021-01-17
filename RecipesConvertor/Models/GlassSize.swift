//
//  GlassSize.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 17/01/2021.
//

import Foundation

enum GlassSize: Int {
    case medium = 200
    case big = 240
    
    init(with rawValue: Int) {
        self = GlassSize(rawValue: rawValue) ?? .big
    }
    
    var ratio: Double {
        switch self {
        case .medium:
            return 5/6
        case .big:
            return 1
        }
    }
}
