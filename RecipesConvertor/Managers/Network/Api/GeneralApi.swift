//
//  GeneralApi.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 13/01/2021.
//

import Foundation

enum GeneralApi {
    case generalData
}

extension GeneralApi :BaseAPI {
    var path: String {
        switch self {
        case .generalData:
            return "generalDetails"
        }
    }
}
