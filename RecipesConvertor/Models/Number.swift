//
//  Fraction.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 10/01/2021.
//

import Foundation

struct Number: Codable {
    var fraction: Fraction {
        didSet {
            decimal = fraction.asDecimal()
        }
    }
    private(set) var decimal: Decimal
    
    init() {
        self.fraction = Fraction()
        self.decimal = fraction.asDecimal()
    }
    
    func multiple(by number: Double) -> Fraction {
        self.decimal.multiple(by: number)
    }
    
    func devide(by number: Double) -> Fraction {
        self.decimal.devide(by: number)
    }
    
    func isValid() -> Bool {
        fraction.isValid()
    }
}

struct Fraction: Codable {
    var value: Int?
    var topValue: Int?
    var bottomValue: Int?
    
    func asString() -> String {
        "\(value.isNotZero ? "\(value!) " : "")\(self.fractionAsString())"
    }
    
    func asAttributedString() -> NSMutableAttributedString {
        NSMutableAttributedString().normal("\(value.isNotZero ? "\(value!)\(self.isValid() ? " " : "")" : "")", fontSize: 18).normal(self.fractionAsString(), fontSize: 16)
    }
    
    func isValid() -> Bool {
        ((topValue != nil && bottomValue != nil) || (topValue == nil && bottomValue == nil)) || !(topValue == 0 && bottomValue != 0)
    }
    
    private func fractionAsString() -> String {
        topValue.isNotZero && bottomValue.isNotZero ? "\(topValue ?? 0)\\\(bottomValue ?? 0)" : ""
    }
    
    func asDecimal() -> Decimal {
        Decimal(number: Double(value ?? 0) + (topValue.isNotZero && bottomValue.isNotZero ? Double(Double(topValue!) / Double(bottomValue!)) : 0))
    }
    
    func isZero() -> Bool {
        (value ?? 0 <= 0 || value == nil) && (topValue ?? 0 <= 0 || topValue == nil)
    }
}

struct Decimal: Codable {
    var number: Double
    
    typealias Rational = (num : Int, den : Int)
    func rationalApproximationOf(_ x0 : Double, withPrecision eps : Double = 1.0E-6) -> Rational {
        var x = x0
        var a = floor(x)
        var (h1, k1, h, k) = (1, 0, Int(a), 1)

        while x - a > eps * Double(k) * Double(k) {
            x = 1.0/(x - a)
            a = floor(x)
            (h1, k1, h, k) = (h, k, h1 + Int(a) * h, k1 + Int(a) * k)
        }
        return (h, k)
    }
    
    func multiple(by number: Double) -> Fraction {
        self.asFractionBest(self.number * number)
    }
    
    func devide(by number: Double) -> Fraction {
        self.asFractionBest(self.number.isZero ? 0 : self.number / number)
    }
    
    func asFraction(_ number: Double? = nil) -> Fraction {
        let (top, bottom) = self.rationalApproximationOf((number ?? self.number))
        let value = Int(top / bottom)
        let topValue = top % bottom
        return Fraction(value: value, topValue: topValue, bottomValue: bottom)
    }
    
    func asFractionBest(_ number: Double? = nil) -> Fraction {
        if number ?? self.number > 10 { return Fraction(value: Int(number ?? self.number), topValue: nil, bottomValue: nil) }
        let (top, bottom) = self.rationalApproximationOf((number ?? self.number).roundedClosest())
        let value = Int(top / bottom)
        let topValue = top % bottom
        return Fraction(value: value, topValue: topValue, bottomValue: bottom)
    }
    
    func asFractionNearestHalf() -> Fraction {
        self.asFraction(self.number.roundToNearestHalf())
    }
}
