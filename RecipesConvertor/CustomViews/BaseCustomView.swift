//
//  BaseCustomView.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 03/01/2021.
//

import UIKit

@IBDesignable
class BaseCustomView: UIView {

    @IBInspectable
    var cornerRadius: CGFloat = 10.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize = CGSize(width: 0, height: 4.0) {
        didSet {
            self.layer.shadowOffset = self.shadowOffset
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat = 4.0 {
        didSet {
            self.layer.shadowRadius = self.shadowRadius
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float = 0.09 {
        didSet {
            self.layer.shadowOpacity = self.shadowOpacity
        }
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.layer.shadowOpacity = self.shadowOpacity
        self.layer.shadowRadius = self.shadowRadius
        self.layer.borderWidth = self.borderWidth
        self.layer.shadowOffset = self.shadowOffset
        self.layer.cornerRadius = self.cornerRadius
    }
}
