//
//  Routable.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 17/01/2021.
//

import Foundation

protocol Routable {
    func showAddRecipe(with recipe: String?)
    func showConvertRecipe(with ingredients: [Ingredient])
    func showGlassSizeAlert(completion: GlassSizeAlertViewController.CompletionHandler?)
}

extension BaseViewController: Routable {
    
    func showAddRecipe(with recipe: String? = nil) {
        let addRecipeViewController = AddRecipeViewController.instantiateFrom(storyboard: .main)
        addRecipeViewController.modalPresentationStyle = .fullScreen
        self.show(addRecipeViewController, sender: nil)
    }
    
    func showConvertRecipe(with ingredients: [Ingredient]) {
        let convertRecipeViewController = ConvertRecipeViewController.instantiateFrom(storyboard: .main)
        convertRecipeViewController.ingredients = ingredients
        convertRecipeViewController.modalPresentationStyle = .fullScreen
        self.show(convertRecipeViewController, sender: nil)
    }
    
    func showGlassSizeAlert(completion: GlassSizeAlertViewController.CompletionHandler?) {
        let glassSizeAlertViewController = GlassSizeAlertViewController.instantiateFrom(storyboard: .main)
        glassSizeAlertViewController.completion = completion
        glassSizeAlertViewController.modalPresentationStyle = .overCurrentContext
        self.present(glassSizeAlertViewController, animated: true)
    }
}
