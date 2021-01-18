//
//  AddRecipeDetailsViewController.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 17/01/2021.
//

import UIKit

typealias AddRecipeDetailsCompletionHandler = ((_ name: String?, _ image: UIImage?, _ shouldSave: Bool) -> ())

class AddRecipeDetailsViewController: BaseViewController {
    
    @IBOutlet weak var addImageViewButton: UIImageView!
    @IBOutlet weak var recipeNameTextField: UITextField!
    @IBOutlet weak var addImageButtonsStackView: UIStackView!
    @IBOutlet weak var addImageBottomButtonsStackView: UIStackView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var completeButton: UIButton!
    
    var completion: AddRecipeDetailsCompletionHandler?
    var name: String?
    var recipeImage: UIImage?
    private lazy var imageUploadManager: ImageUploadManager? = {
        ImageUploadManager(delegate: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }
    
    private func setupUI() {
        self.recipeNameTextField.text = self.name
        self.completeButton.isEnabled = self.name != nil
        if let recipeImage = self.recipeImage {
            self.addImageViewButton.image = recipeImage
            self.addImageButtonsStackView.isHidden = true
            self.addImageBottomButtonsStackView.isHidden = false
        }
        self.addImageViewButton.fullyRound(diameter: 8)
        self.recipeNameTextField.addTarget(self, action: #selector(recipeNameWasChanged), for: .editingChanged)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        guard let location = touches.first?.location(in: self.view) else { return }
        if !self.alertView.frame.contains(location) {
            self.dismiss(animated: true) {
                self.completion?(self.name, self.recipeImage, false)
            }
        }
    }
    
    @objc func recipeNameWasChanged(_ sender: UITextField) {
        self.completeButton.isEnabled = !(sender.text?.isEmpty ?? true)
        self.name = sender.text
    }
    
    @IBAction func onAddGaleryImage(_ sender: UIButton) {
        self.imageUploadManager?.openGallery()
    }
    
    @IBAction func onAddCameraImage(_ sender: UIButton) {
        self.imageUploadManager?.openCamera()
    }
    
    @IBAction func onComplete(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.completion?(self.name, self.recipeImage, true)
        }
    }
    
    @IBAction func onClose(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.completion?(self.name, self.recipeImage, false)
        }
    }
}

extension AddRecipeDetailsViewController: ImageUploadManagerDelegate {
    
    func imageWasPicked(image: UIImage?) {
        self.recipeImage = image
        self.addImageViewButton.image = image
        self.addImageButtonsStackView.isHidden = true
        self.addImageBottomButtonsStackView.isHidden = false
    }
}
