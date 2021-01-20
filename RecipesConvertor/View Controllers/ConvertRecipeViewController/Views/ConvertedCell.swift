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
    
    func description(for decimal: Decimal? = nil) -> String {
        self.description(for: decimal?.number)
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
    var multiplier: Double = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    func configure(with ingredient: Ingredient, multiplier: Double = 1) {
        self.ingredient = ingredient
        self.multiplier = multiplier
        
        let convertable = SessionManager.shared.getConvertableIfExist(ingredient.name)
        if ingredient.unit == .glass {
            self.convertionType = .mililiter
        }
        
        self.productNameLabel.text = ingredient.name
        self.beforeUnitLabel.text = ingredient.unit?.description(for: ingredient.amount?.decimal)
        self.beforeAmountLabel.attributedText = ingredient.amount?.fraction.asBest().asAttributedString()
        let multiplied = ingredient.amount?.multiple(by: multiplier)
        self.afterUnitLabel.text = ingredient.unit?.description(for: multiplied?.asDecimal())
        let afterAmountText = multiplied?.asBest().asAttributedString()
        self.afterAmountLabel.attributedText = multiplier <= 0 || afterAmountText?.string.trimWhiteSpaces().isEmpty ?? true ? NSAttributedString(string: "0") : afterAmountText
        self.flipButtonView.isHidden = !(ingredient.isConvetable() && SessionManager.shared.isConvertionEnabled ?? false)
        
        self.flippedProductNameLabel.text = ingredient.name
        self.flippedBeforeUnitLabel.text = ingredient.unit?.description(for: multiplied?.asDecimal())
        self.flippedBeforeAmountLabel.attributedText = self.afterAmountLabel.attributedText
        if let ratio = convertable?.ratio {
            let flippedMultiplied = convertionType == .glass ? ingredient.unit?.convertGlassRatio(from: ratio) : ingredient.unit?.convertMililiterRatio(from: ratio)
            let flippedConvertedAmount = convertionType == .glass ? ((flippedMultiplied ?? 0) * (multiplied?.asDecimal().number ?? 0)) : Double(Int(((flippedMultiplied ?? 0) * (multiplied?.asDecimal().number ?? 0))))
            self.flippedAfterUnitLabel.text = self.convertionType.description(for: flippedConvertedAmount)
            let flippedConvertedAmountFraction = Decimal(number: flippedConvertedAmount).asFractionBest()
            let flippedAfterAmountText = flippedConvertedAmountFraction.asAttributedString()
            self.flippedAfterAmountLabel.attributedText = flippedAfterAmountText.string.trimWhiteSpaces().isEmpty ? NSAttributedString(string: "0") : flippedAfterAmountText
        } else {
            self.flippedAfterUnitLabel.text = ingredient.unit?.description(for: multiplied?.asDecimal())
        }
        self.flippedDisclaimerLabel.text = "*המידות מחושבות לפי כוס של \(SessionManager.shared.glassType.rawValue) מיליליטר\n**תיתכן סטייה קלה במידות"
    }
    
    @IBAction func onSwitchConvertionType(_ sender: UIButton) {
        switch self.convertionType {
        case .glass:
            self.convertionType = .mililiter
        case .mililiter:
            self.convertionType = .glass
        }
        self.setupflippedAfterData()
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
    
    private func setupflippedAfterData() {
        
        guard let ingredient = self.ingredient else { return }
        let multiplied = ingredient.amount?.multiple(by: self.multiplier)
        let convertable = SessionManager.shared.getConvertableIfExist(ingredient.name)
        
        if let ratio = convertable?.ratio {
            let flippedMultiplied = convertionType == .glass ? ingredient.unit?.convertGlassRatio(from: ratio) : ingredient.unit?.convertMililiterRatio(from: ratio)
            let flippedConvertedAmount = convertionType == .glass ? ((flippedMultiplied ?? 0) * (multiplied?.asDecimal().number ?? 0)) : Double(Int(((flippedMultiplied ?? 0) * (multiplied?.asDecimal().number ?? 0))))
            self.flippedAfterUnitLabel.text = self.convertionType.description(for: flippedConvertedAmount)
            let flippedConvertedAmountFraction = Decimal(number: flippedConvertedAmount).asFractionBest()
            self.flippedAfterAmountLabel.attributedText = flippedConvertedAmountFraction.isZero() ? NSAttributedString(string: "0") : flippedConvertedAmountFraction.asAttributedString()
        } else {
            self.flippedAfterUnitLabel.text = ingredient.unit?.description(for: multiplied?.asDecimal().number)
        }
    }
}
