//
//  SessionManager.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 12/01/2021.
//

import Foundation

enum GlassMililiter: Int {
    case medium = 200
    case big = 240
    
    var ratio: Double {
        switch self {
        case .medium:
            return 5/6
        case .big:
            return 1
        }
    }
}

class SessionManager {
        
    static let shared: SessionManager = SessionManager()
    
    private init() {}
    
    var generalDetails: GeneralDetails?
    var convertables: [Convertable]? {
        self.generalDetails?.convertables
    }
    var units: [UnitType] = UnitType.allCases
    var glassType: GlassMililiter = .big
    var isConvertionEnabled: Bool?
    
//    var convertables: [Convertable] = [
//        Convertable(name: "קמח", ratioTypes: [
//            ConvertRatio(ratio: 1.3, unit: "כוס"),
//            ConvertRatio(ratio: 0.2, unit: "גלון"),
//            ConvertRatio(ratio: 20, unit: "כפית"),
//            ConvertRatio(ratio: 10, unit: "כף"),
//            ConvertRatio(ratio: 2000, unit: "מיליגרם"),
//            ConvertRatio(ratio: 1, unit: "קילו"),
//            ConvertRatio(ratio: 200, unit: "גרם"),
//            ConvertRatio(ratio: 1, unit: "ליטר"),
//            ConvertRatio(ratio: 1234, unit: "מיליליטר"),
//            ConvertRatio(ratio: 1, unit: "יחידה")
//        ]),
//        Convertable(name: "סוכר", ratioTypes: [
//            ConvertRatio(ratio: 1.3, unit: "כוס"),
//            ConvertRatio(ratio: 0.2, unit: "גלון"),
//            ConvertRatio(ratio: 20, unit: "כפית"),
//            ConvertRatio(ratio: 10, unit: "כף"),
//            ConvertRatio(ratio: 2000, unit: "מיליגרם"),
//            ConvertRatio(ratio: 1, unit: "קילו"),
//            ConvertRatio(ratio: 200, unit: "גרם"),
//            ConvertRatio(ratio: 1, unit: "ליטר"),
//            ConvertRatio(ratio: 1234, unit: "מיליליטר"),
//            ConvertRatio(ratio: 1, unit: "יחידה")
//        ]),
//        Convertable(name: "קמח מלא", ratioTypes: [
//            ConvertRatio(ratio: 1.3, unit: "כוס"),
//            ConvertRatio(ratio: 0.2, unit: "גלון"),
//            ConvertRatio(ratio: 20, unit: "כפית"),
//            ConvertRatio(ratio: 10, unit: "כף"),
//            ConvertRatio(ratio: 2000, unit: "מיליגרם"),
//            ConvertRatio(ratio: 1, unit: "קילו"),
//            ConvertRatio(ratio: 200, unit: "גרם"),
//            ConvertRatio(ratio: 1, unit: "ליטר"),
//            ConvertRatio(ratio: 1234, unit: "מיליליטר"),
//            ConvertRatio(ratio: 1, unit: "יחידה")
//        ]),
//    ]
    
    func getConvertableIfExist(_ productName: String?) -> Convertable? {
        guard let productName = productName else { return nil }
        return convertables?.first{ $0.name == productName }
    }
}
