//
//  UIVIewExtension.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 03/01/2021.
//
import UIKit

protocol Shadowed {}
protocol XibInstantiable {}
protocol Rounded {}
protocol Renderable {}

extension UIView {
    
    func round(corners: UIRectCorner, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        self.clipsToBounds = false
        self.removeCorners()
        self.layer.roundCorners(corners: corners, radius: radius)
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

    func fullyRound(diameter: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = diameter / 2
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor;
    }
    
    func removeCorners() {
        self.layer.mask = nil
        self.layer.shadowOpacity = 0.0
        self.layer.shadowRadius = 0.0
        self.layer.shadowColor = UIColor.clear.cgColor
    }
    
    func sublayerNamedBorderLayer() -> CAShapeLayer? {
        guard let sublayers = self.layer.sublayers else {
            return nil
        }
        for layer: CALayer in sublayers {
            if layer.name == "borderLayer" {
                return layer as? CAShapeLayer
            }
        }
        return nil
    }
    
    func removeAllGestureRecognizers() {
        self.gestureRecognizers?.forEach { self.removeGestureRecognizer($0) }
    }
}

private extension UIView {
    
    @discardableResult func _round(corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))

        self.layer.masksToBounds = true
        self.layer.mask = nil
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        return mask
    }
    
    func addBorder(mask: CAShapeLayer, borderColor: UIColor, borderWidth: CGFloat) {
        var borderLayer = sublayerNamedBorderLayer()
        if  borderLayer == nil {
            borderLayer = CAShapeLayer()
        }
        borderLayer?.path = mask.path
        borderLayer?.fillColor = UIColor.clear.cgColor
        borderLayer?.strokeColor = borderColor.cgColor
        borderLayer?.lineWidth = borderWidth
        borderLayer?.frame = bounds
        if let borderLayer = borderLayer {
            self.layer.addSublayer(borderLayer)
        }
    }
    
}

extension Shadowed where Self: UIView {
    
    // MARK: Drop Shadow for View
    func dropShadowWith(offset: CGSize,
                        radius: CGFloat,
                        opacity: Float,
                        color: UIColor = UIColor.black,
                        clipsToBound: Bool = false, shouldRisterize: Bool = true) {
        
        self.layer.shadowOffset = offset
        self.layer.shadowColor = color.cgColor
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.shouldRasterize = shouldRisterize
        self.layer.rasterizationScale = UIScreen.main.scale

        self.clipsToBounds = clipsToBounds
    }
}

extension Rounded where Self: UIView {
    
    // MARK: Custom rounded corners for View
    
    func setRoundedCorners(radius: CGFloat) {
        self.layer.cornerRadius = radius
    }
    
    func setRounded(corners: UIRectCorner, radius: CGSize) {
        
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: radius)
        let layer = CAShapeLayer()
        
        layer.frame = self.bounds
        layer.path = maskPath.cgPath
        
        self.layer.mask = layer
        self.layer.masksToBounds = false
    }
}

extension XibInstantiable where Self: UIView {
    
    // MARK: Instantiate custom view from xib
    
    func xibinstantiate() -> UIView {
        
        let view = self.instantiateViewFromXib()
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return view
    }
    
    func instantiateViewFromXib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
}

class ShadowedView: UIView, Shadowed, Rounded {}
class RoundedView: UIView, Rounded {}

@IBDesignable
extension UIView {
    
    @IBInspectable
    var circled: Bool {
        get {
            return self.circled
        }
        set(isCircled) {
            layer.cornerRadius = isCircled ? (frame.size.height / 2) : 0
            layer.masksToBounds = isCircled
            clipsToBounds = isCircled
            aspectRatio()
        }
    }
    
    func aspectRatio() {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint =
            NSLayoutConstraint(item: self,
                               attribute: NSLayoutConstraint.Attribute.height,
                               relatedBy: NSLayoutConstraint.Relation.equal,
                               toItem: self,
                               attribute: NSLayoutConstraint.Attribute.width,
                               multiplier: frame.size.height / frame.size.width,
                               constant: 0)
        
        constraint.isActive = true
        addConstraint(constraint)
    }
}

extension CALayer {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        
        self.mask = nil
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        mask = shape
    }
}
