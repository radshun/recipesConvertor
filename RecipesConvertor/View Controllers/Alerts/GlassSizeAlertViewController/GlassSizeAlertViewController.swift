//
//  GlassSizeAlertViewController.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 17/01/2021.
//

import UIKit

typealias GlassSizeAlertCompletionHandler = ((_ isChanged: Bool) -> ())

class GlassSizeAlertViewController: BaseViewController {
    
    @IBOutlet weak var mediumGlassImageView: UIImageView!
    @IBOutlet weak var bigGlassImageView: UIImageView!
    @IBOutlet weak var mediumView: BaseGradientView!
    @IBOutlet weak var bigView: BaseGradientView!
    @IBOutlet weak var alertView: UIView!
    
    private var initialGlassType: GlassSize = SessionManager.shared.glassType
    private var glassType: GlassSize = SessionManager.shared.glassType
    var completion: GlassSizeAlertCompletionHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        guard let location = touches.first?.location(in: self.view) else { return }
        if !self.alertView.frame.contains(location) {
            self.dismiss(animated: true) {
                self.completion?(false)
            }
        }
    }
    
    private func setupUI() {
        self.changeGlass(to: self.glassType)
    }
    
    @IBAction func onMediumGlass(_ sender: UIButton) {
        self.changeGlass(to: .medium)
    }
    
    @IBAction func onBigGlass(_ sender: UIButton) {
        self.changeGlass(to: .big)
    }
    
    @IBAction func onChangeGlass(_ sender: UIButton) {
        SessionManager.shared.glassType = self.glassType
        self.dismiss(animated: true) {
            self.completion?(self.initialGlassType != self.glassType)
        }
    }
    
    @IBAction func onClose(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.completion?(false)
        }
    }
    
    private func changeGlass(to size: GlassSize) {
        switch size {
        case .medium:
            self.mediumView.topGradientColor = .topBlue
            self.mediumView.bottomGradientColor = .topBlue
            self.mediumGlassImageView.isHidden = false
            self.bigView.topGradientColor = .clear
            self.bigView.bottomGradientColor = .clear
            self.bigGlassImageView.isHidden = true
        case .big:
            self.mediumView.topGradientColor = .clear
            self.mediumView.bottomGradientColor = .clear
            self.mediumGlassImageView.isHidden = true
            self.bigView.topGradientColor = .topBlue
            self.bigView.bottomGradientColor = .topBlue
            self.bigGlassImageView.isHidden = false
        }
        self.glassType = size
    }
}
