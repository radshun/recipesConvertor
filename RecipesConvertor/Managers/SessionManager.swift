//
//  SessionManager.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 12/01/2021.
//

import Foundation

class SessionManager {
        
    static let shared: SessionManager = SessionManager()
    
    private init() {
        self.glassType = GlassSize(with: UserDefaults.standard.integer(forKey: UserDefaults.glassType))
    }
    
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

extension UserDefaults {
    static let glassType = "GlassType"
}
