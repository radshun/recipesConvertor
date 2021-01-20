//
//  BaseUITextField.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 20/01/2021.
//

import UIKit

@IBDesignable
class BaseUITextField: UITextField {
    
    @IBInspectable
    var numberTypeSafe: Bool = false
    
    @IBInspectable
    var maxRange: Int = 100
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return !self.numberTypeSafe
        }
        return super.canPerformAction(action, withSender: sender)
    }

    func handleRange(_ range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = self.text?.count ?? 0
        if range.length + range.location > currentCharacterCount {
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= self.maxRange
    }
}
