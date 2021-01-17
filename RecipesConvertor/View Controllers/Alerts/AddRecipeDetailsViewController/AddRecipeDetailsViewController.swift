//
//  AddRecipeDetailsViewController.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 17/01/2021.
//

import UIKit

typealias AddRecipeDetailsCompletionHandler = ((_ name: String?, _ image: UIImage?) -> ())

class AddRecipeDetailsViewController: BaseViewController {
    
    @IBOutlet weak var addImageViewButton: UIImageView!
    @IBOutlet weak var recipeNameTextField: UITextField!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var completeButton: UIButton!
    
    var completion: AddRecipeDetailsCompletionHandler?
    private var recipeImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.recipeNameTextField.addTarget(self, action: #selector(recipeNameWasChanged), for: .editingChanged)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        guard let location = touches.first?.location(in: self.view) else { return }
        if !self.alertView.frame.contains(location) {
            self.dismiss(animated: true) {
                self.completion?(nil,nil)
            }
        }
    }
    
    @objc func recipeNameWasChanged(_ sender: UITextField) {
        self.completeButton.isEnabled = !(sender.text?.isEmpty ?? true)
    }
    
    @IBAction func onAddImage(_ sender: UIButton) {
        
    }
    
    @IBAction func onComplete(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.completion?(self.recipeNameTextField.text, self.recipeImage)
        }
    }
    
    @IBAction func onClose(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.completion?(nil,nil)
        }
    }
}
