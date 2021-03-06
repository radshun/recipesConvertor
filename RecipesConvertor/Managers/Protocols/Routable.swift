//
//  Routable.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 17/01/2021.
//

import UIKit

protocol Routable {
    func showAddRecipe(with recipe: Recipe?)
    func showConvertRecipe(with recipe: Recipe)
    func showGlassSizeAlert(completion: GlassSizeAlertCompletionHandler?)
    func showAddRecipeDetailsAlert(with name: String?, image: UIImage?, completion: AddRecipeDetailsCompletionHandler?)
}

extension BaseViewController: Routable {
    
    func showAddRecipe(with recipe: Recipe? = nil) {
        let addRecipeViewController = AddRecipeViewController.instantiateFrom(storyboard: .main)
        addRecipeViewController.recipe = recipe
        addRecipeViewController.modalPresentationStyle = .fullScreen
        self.show(addRecipeViewController, sender: nil)
    }
    
    func showConvertRecipe(with recipe: Recipe) {
        let convertRecipeViewController = ConvertRecipeViewController.instantiateFrom(storyboard: .main)
        convertRecipeViewController.recipe = recipe
        convertRecipeViewController.modalPresentationStyle = .fullScreen
        self.show(convertRecipeViewController, sender: nil)
    }
    
    func showGlassSizeAlert(completion: GlassSizeAlertCompletionHandler?) {
        let glassSizeAlertViewController = GlassSizeAlertViewController.instantiateFrom(storyboard: .main)
        glassSizeAlertViewController.completion = completion
        glassSizeAlertViewController.modalPresentationStyle = .overCurrentContext
        self.present(glassSizeAlertViewController, animated: true)
    }
    
    func showAddRecipeDetailsAlert(with name: String? = nil, image: UIImage? = nil, completion: AddRecipeDetailsCompletionHandler?) {
        let addRecipeDetailsViewController = AddRecipeDetailsViewController.instantiateFrom(storyboard: .main)
        addRecipeDetailsViewController.name = name
        addRecipeDetailsViewController.recipeImage = image
        addRecipeDetailsViewController.completion = completion
        addRecipeDetailsViewController.modalPresentationStyle = .overCurrentContext
        self.present(addRecipeDetailsViewController, animated: true)
    }
}
