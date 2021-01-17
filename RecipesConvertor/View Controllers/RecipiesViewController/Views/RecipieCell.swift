//
//  RecipiesCell.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 06/01/2021.
//

import UIKit

class RecipieCell: UITableViewCell {

    @IBOutlet weak var recipeNameLabel: UILabel!
    
    func configure(with recipe: Recipe) {
        self.recipeNameLabel.text = recipe.name
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
}
