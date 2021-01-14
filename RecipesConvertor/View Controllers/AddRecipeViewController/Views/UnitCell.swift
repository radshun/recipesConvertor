//
//  UnitCell.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 10/01/2021.
//

import UIKit

class UnitCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    var type: UnitType?
    
    func configure(with type: UnitType) {
        self.type = type
        self.nameLabel.text = type.single
    }
}
