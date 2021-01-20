//
//  RecipiesCell.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 06/01/2021.
//

import UIKit

protocol RecipieCellDelegate {
    func addImagePressed(in indexPath: IndexPath)
}

class RecipieCell: UITableViewCell {

    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var noImageButton: UIButton!
    @IBOutlet weak var hasImageView: UIView!
    
    var delegate: RecipieCellDelegate?
    var indexPath: IndexPath?
    
    func configure(with recipe: Recipe, indexPath: IndexPath, delegate: RecipieCellDelegate?) {
        self.indexPath = indexPath
        self.delegate = delegate
        self.recipeNameLabel.text = recipe.name
        self.recipeImageView.image = recipe.image
        self.noImageButton.isHidden = recipe.image != nil
        self.hasImageView.isHidden = recipe.image == nil
        self.recipeImageView.fullyRound(diameter: 12)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    @IBAction func onAddImage(_ sender: UIButton) {
        guard let indexPath = self.indexPath else { return }
        self.delegate?.addImagePressed(in: indexPath)
    }
}
