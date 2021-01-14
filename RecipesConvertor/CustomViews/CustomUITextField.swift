//
//  CustomUITextField.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 11/01/2021.
//

import UIKit

class CustomUITextField: UITextField {
    
    var placeHolderColor: UIColor? {
        didSet {
            if self.placeHolderColor != nil {
                self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: self.placeHolderColor!])
            }
        }
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    func removeError() {
        if self.placeHolderColor != nil {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: self.placeHolderColor!])
        } else {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: nil)
        }
    }
    
    func setError() {
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.errorRed])
    }
}

