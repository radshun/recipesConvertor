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
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return !self.numberTypeSafe
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
