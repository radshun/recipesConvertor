//
//  Colors.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 07/01/2021.
//

import UIKit

extension UIColor {
    
    convenience init(hex:Int, alpha:Float) {
        self.init(red:(hex >> 16) & 0xFF, green:(hex >> 8) & 0xFF, blue:hex & 0xFF, alpha:alpha)
    }
    
    convenience init(red: Int, green: Int, blue: Int, alpha:Float) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    static let topBlue = UIColor(hex: 0x08aac2, alpha: 1.0)
    static let bottomBlue = UIColor(hex: 0x60c7d6, alpha: 1.0)
    static let blueImage = UIColor(red: 84, green: 187, blue: 207, alpha: 1)
    static let errorRed = UIColor(hex: 0xed3e3e, alpha: 1)
}
