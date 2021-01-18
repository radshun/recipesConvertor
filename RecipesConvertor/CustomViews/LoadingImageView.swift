//
//  LoadingView.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 18/01/2021.
//

import UIKit

class LoadingImageView: UIImageView {
    
    var finishImageName: String = "checkmark"
    
    func startLoading() {
        DispatchQueue.main.async { [unowned self] in
            self.image = UIImage.gif(asset: "loading")
        }
    }
    
    func stopLoading() {
        DispatchQueue.main.async { [unowned self] in
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.alpha = 0
            } completion: { _ in
                self.image = UIImage(named: self.finishImageName)
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.alpha = 1
                }
            }
        }
    }
}
