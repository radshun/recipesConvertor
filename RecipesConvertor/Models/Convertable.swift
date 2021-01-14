//
//  Convertable.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 12/01/2021.
//

import Foundation

struct Convertable: Decodable {
    let name: String
    let ratio: Double
    
//    func ratio(for unit: String?) -> Double? {
//        guard let unit = unit else { return nil }
//        return ratioTypes.first{ $0.unit == unit }?.ratio
//    }
//
//    func resultUnit(for number: Double) -> String {
//        number <= 1 ? resultUnit?.single ?? "כוס" : resultUnit?.many ?? "כוסות"
//    }
//
//    func contains(unit: String?) -> Bool {
//        ratioTypes.contains{ $0.unit == unit }
//    }
}

//struct ConvertRatio: Decodable {
//    let ratio: Double
//    let unit: String
//}
//
//struct AmountDescription: Decodable {
//    let single: String?
//    let many: String?
//}
