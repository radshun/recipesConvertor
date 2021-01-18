//
//  BaseGradientView.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 03/01/2021.
//

import UIKit


/*@IBDesignable*/ class BaseGradientView: UIView, XibInstantiable, Shadowed {
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleIcon: UIImageView!
    @IBOutlet weak var rightTitleIcon: UIImageView!
    @IBOutlet weak var bluredVisualView: UIVisualEffectView!
    
    private lazy var gradientLayer = CAGradientLayer()
    private var isHorizontal = false
    
    // MARK: - Borders/Corners
    
    @IBInspectable var cornersRadius: CGFloat = 0.0 {
        didSet {
            self.backgroundView.layer.cornerRadius = self.cornersRadius
        }
    }
    
    @IBInspectable var bottomCornersRadius: CGFloat = 0.0 {
        didSet {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomRight, .bottomLeft], cornerRadii: CGSize(width: self.bottomCornersRadius, height: self.bottomCornersRadius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.backgroundView.layer.mask = mask
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.backgroundView.layer.borderWidth = self.borderWidth
        }
    }
    
    // MARK: - Color
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.backgroundView.layer.borderColor = self.borderColor.cgColor
            self.backgroundView.clipsToBounds = true
        }
    }
    
    @IBInspectable var fillColor: UIColor = UIColor.clear {
        didSet {
            self.backgroundView.backgroundColor = self.fillColor
        }
    }
    
    @IBInspectable var isHorizontalGradient: Bool = false {
        didSet {
            self.isHorizontal = self.isHorizontalGradient
            self.setGradient(topGradientColor: self.topGradientColor, bottomGradientColor: self.bottomGradientColor, isHorizontal: self.isHorizontalGradient)
        }
    }
    
    // MARK: - Gradient
    
    @IBInspectable var topGradientColor: UIColor? {
        didSet {
            self.setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    @IBInspectable var bottomGradientColor: UIColor? {
        didSet {
            self.setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    // MARK: - Shadow
    
    @IBInspectable var hasShadow: Bool = true {
        didSet {
            self.layer.shadowOpacity = self.hasShadow ? 0.16 : 0
        }
    }
    
    // MARK: - Private
    
    private func setGradient(topGradientColor: UIColor?, bottomGradientColor: UIColor?, isHorizontal: Bool = false) {
        
        if let topGradientColor = topGradientColor, let bottomGradientColor = bottomGradientColor {
            var frame = self.bounds
            frame.size.width += 50.0
            self.gradientLayer.frame = frame
            self.gradientLayer.colors = [topGradientColor.cgColor, bottomGradientColor.cgColor]

            if isHorizontal {
                self.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                self.gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            } else {
                self.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
                self.gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            }

            self.backgroundView.layer.insertSublayer(self.gradientLayer, at: 0)

        } else {
            self.gradientLayer.removeFromSuperlayer()
        }
    }

    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        if self.topGradientColor != nil || self.bottomGradientColor != nil {
            self.gradientLayer.frame = self.bounds
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.xibinstantiate())
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.addSubview(self.xibinstantiate())
        self.setupUI()
    }
    
    // MARK: - Default custom data
    
    private func setupUI() {
        self.dropShadowWith(offset: CGSize(width: 0, height: 3.0), radius: 6.0, opacity: 0.16)
    }
    
    override func prepareForInterfaceBuilder() {
        self.setupUI()
    }
}
