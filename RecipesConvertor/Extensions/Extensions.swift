//
//  Extensions.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 07/01/2021.
//

import UIKit

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Optional where Wrapped == Int {
    var isNotZero: Bool {
        self != nil && self != 0
    }
}

extension UITableView {
    func scrollToBottom() {
        self.scrollToRow(at: IndexPath(row: self.numberOfRows(inSection: 0) - 1, section: 0), at: .bottom, animated: true)
    }
}

extension UISlider {
    var thumbCenterX: CGFloat {
        let trackRect = self.trackRect(forBounds: frame)
        let thumbRect = self.thumbRect(forBounds: bounds, trackRect: trackRect, value: value)
        return thumbRect.midX + 16.9
    }
}

extension Double {
    
    enum FractionType: CaseIterable {
        case half
        case third
        case fourth
        case fifth
        case eight
    }
    
    func roundToNearestHalf() -> Double {
        self.round(nearest: 0.5)
    }
    
    func roundedClosest() -> Double {
        var minDifference: Double = 1
        var best: FractionType = .half
        FractionType.allCases.forEach {
            let difference = abs(self - self.rounded(with: $0))
            if difference <= minDifference {
                minDifference = difference
                best = $0
            }
        }
        return rounded(with: best)
    }
    
    func rounded(with type: FractionType) -> Double {
        switch type {
        case .half:
            return self.round(nearest: 0.5)
        case .third:
            return self.round(nearest: 0.3333333333333333333333333333333333333333)
        case .fourth:
            return self.round(nearest: 0.25)
        case .fifth:
            return self.round(nearest: 0.2)
        case .eight:
            return self.round(nearest: 0.125)
        }
    }
    
    func round(nearest: Double) -> Double {
        let n = 1/nearest
        let numberToRound = self * n
        return numberToRound.rounded() / n
    }

    func floor(nearest: Double) -> Double {
        let intDiv = Double(Int(self / nearest))
        return intDiv * nearest
    }
}

extension String {
    func trimWhiteSpaces() -> String {
        self.replacingOccurrences(of: " ", with: "")
    }
}

extension Double {
    func asFraction() -> Fraction {
        Decimal(number: self).asFraction()
    }
}
