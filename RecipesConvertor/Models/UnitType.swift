//
//  UnitType.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 14/01/2021.
//

import Foundation

enum UnitType: Int, Codable ,CaseIterable {
    case unit
    case mililiter
    case liter
    case miligram
    case gram
    case kilogram
    case teaSpoon
    case spoon
    case glass
    case pound
    
    var glassMultiplyRatio: Double {
        switch self {
        case .unit:
            return 1
        case .mililiter:
            return 0.00416667
        case .liter:
            return 4.166666
        case .miligram:
            return 1/1000 * self.glassRatio
        case .gram:
            return 1 * self.glassRatio
        case .kilogram:
            return 1000 * self.glassRatio
        case .teaSpoon:
            return 5 * self.glassRatio
        case .spoon:
            return 15 * self.glassRatio
        case .glass:
            return 1
        case .pound:
            return 453.59 * self.glassRatio
        }
    }
    
    var isConvertableFromratio: Bool {
        switch self {
        case .unit, .mililiter, .liter, .glass:
            return false
        case .miligram, .gram, .kilogram, .teaSpoon, .spoon, .pound:
            return true
        }
    }
    
    var single: String {
        switch self {
        case .unit:
            return "יחידה"
        case .mililiter:
            return "מיליליטר"
        case .liter:
            return "ליטר"
        case .miligram:
            return "מיליגרם"
        case .gram:
            return "גרם"
        case .kilogram:
            return "קילוגרם"
        case .teaSpoon:
            return "כפית"
        case .spoon:
            return "כף"
        case .glass:
            return "כוס"
        case .pound:
            return "פאונד"
        }
    }
    
    var many: String {
        switch self {
        case .unit:
            return "יחידות"
        case .mililiter:
            return "מיליליטר"
        case .liter:
            return "ליטר"
        case .miligram:
            return "מיליגרם"
        case .gram:
            return "גרם"
        case .kilogram:
            return "קילוגרם"
        case .teaSpoon:
            return "כפיות"
        case .spoon:
            return "כפות"
        case .glass:
            return "כוסות"
        case .pound:
            return "פאונד"
        }
    }
    
    var isConvertable: Bool {
        switch self {
        case .unit:
            return false
        case .miligram, .gram, .kilogram, .teaSpoon, .spoon, .mililiter, .liter, .glass, .pound:
            return true
        }
    }
    
    private var glassRatio: Double {
        SessionManager.shared.glassType.ratio
    }
    
    func description(for amount: Double? = nil) -> String {
        amount ?? 0 <= 1 ? self.single : self.many
    }
    
    func convertGlassRatio(from ratio: Double) -> Double {
        self.isConvertableFromratio ? self.glassMultiplyRatio / ratio : self.glassMultiplyRatio
    }
    
    func convertMililiterRatio(from ratio: Double) -> Double {
        self.convertGlassRatio(from: ratio) * Double(SessionManager.shared.glassType.rawValue)
    }
    
    enum Key: CodingKey {
        case rawValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        self = UnitType(rawValue: rawValue) ?? .unit
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(self.rawValue, forKey: .rawValue)
    }
}
