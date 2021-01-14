//
//  ConvertedCell.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 07/01/2021.
//

import UIKit

enum ConvertionType {
    case glass
    case mililiter
    
    func description(for amount: Double? = nil) -> String {
        switch self {
        case .glass:
            return UnitType.glass.description(for: amount)
        case .mililiter:
            return UnitType.mililiter.description(for: amount)
        }
    }
}

class ConvertedCell: UITableViewCell {

    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var beforeUnitLabel: UILabel!
    @IBOutlet weak var beforeAmountLabel: UILabel!
    @IBOutlet weak var afterUnitLabel: UILabel!
    @IBOutlet weak var afterAmountLabel: UILabel!
    @IBOutlet weak var flipButtonView: UIView!
    
    @IBOutlet weak var flippedProductNameLabel: UILabel!
    @IBOutlet weak var flippedBeforeUnitLabel: UILabel!
    @IBOutlet weak var flippedBeforeAmountLabel: UILabel!
    @IBOutlet weak var flippedAfterUnitLabel: UILabel!
    @IBOutlet weak var flippedAfterAmountLabel: UILabel!
    @IBOutlet weak var flippedDisclaimerLabel: UILabel!
    
    @IBOutlet weak var convertView: UIView!
    @IBOutlet weak var flippedView: UIView!
    
    var ingredient: Ingredient?
    var convertionType: ConvertionType = .glass
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    func configure(with ingredient: Ingredient, multiplier: Double = 1) {
        self.ingredient = ingredient
        
        let convertable = SessionManager.shared.getConvertableIfExist(ingredient.name)
        
        self.productNameLabel.text = ingredient.name
        self.beforeUnitLabel.text = ingredient.unit?.description(for: ingredient.amount?.decimal.number)
        self.beforeAmountLabel.attributedText = ingredient.amount?.fraction.asAttributedString()
        let multiplied = ingredient.amount?.multiple(by: multiplier)
        self.afterUnitLabel.text = ingredient.unit?.description(for: multiplied?.asDecimal().number)
        self.afterAmountLabel.attributedText = multiplier == 0 ? NSAttributedString(string: "0") : multiplied?.asAttributedString()
        self.flipButtonView.isHidden = !(ingredient.unit?.isConvertable ?? false || SessionManager.shared.isConvertionEnabled ?? false)
        
        self.flippedProductNameLabel.text = ingredient.name
        self.flippedBeforeUnitLabel.text = ingredient.unit?.description(for: multiplied?.asDecimal().number)
        self.flippedBeforeAmountLabel.attributedText = self.afterAmountLabel.attributedText
        if let ratio = convertable?.ratio {
            let flippedMultiplied = convertionType == .glass ? ingredient.unit?.convertGlassRatio(from: ratio) : ingredient.unit?.convertMililiterRatio(from: ratio)
            let flippedConvertedAmount = ((flippedMultiplied ?? 0) * (multiplied?.asDecimal().number ?? 0))
            self.flippedAfterUnitLabel.text = self.convertionType.description(for: flippedConvertedAmount)
            self.flippedAfterAmountLabel.attributedText = flippedConvertedAmount == 0 ? NSAttributedString(string: "0") : flippedConvertedAmount.asFraction().asAttributedString()
        } else {
            self.flippedAfterUnitLabel.text = ingredient.unit?.description(for: multiplied?.asDecimal().number)
        }
        self.flippedDisclaimerLabel.text = "*המידות מחושבות לפי כוס של \(SessionManager.shared.glassType.rawValue) מיליליטר\n**תיתכן סטייה קלה במידות"
    }
    
    @IBAction func onConvertPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            self.convertView.isHidden = true
            self.flippedView.isHidden = false
        }
        UIView.transition(with: self.contentView, duration: 0.4, options: .transitionFlipFromRight, animations: nil)
    }
    
    @IBAction func onFlipBackPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            self.convertView.isHidden = false
            self.flippedView.isHidden = true
        }
        UIView.transition(with: self.contentView, duration: 0.4, options: .transitionFlipFromLeft, animations: nil)
    }
}
