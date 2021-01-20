//
//  RecipieIngredientCell.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 06/01/2021.
//

import UIKit

enum IngredientDropDownType: CaseIterable {
    case amout
    case units
    case none
}

protocol RecipieIngredientCellDelegate {
    func reloadItem(at indexPath: IndexPath, with ingredient: IngredientCellModel)
    func valueHasChanged(at indexPath: IndexPath, with ingredient: IngredientCellModel)
    func deleteItem(at indexPath: IndexPath)
}

class RecipieIngredientCell: UITableViewCell {

    @IBOutlet weak var unitsView: UIView!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var unitsButton: UIButton!
    @IBOutlet weak var amountButton: UIButton!
    @IBOutlet weak var unitsTopImageView: UIImageView!
    @IBOutlet weak var amountTopImageView: UIImageView!
    @IBOutlet weak var amountDisplayView: UIView!
    @IBOutlet weak var productDisplayView: UIView!
    @IBOutlet weak var productTextField: CustomUITextField!
    @IBOutlet weak var amountTextField: CustomUITextField!
    @IBOutlet weak var amountNumberTextField: UITextField!
    @IBOutlet weak var fractionTopAmountTextField: UITextField!
    @IBOutlet weak var fractionBottomAmountTextField: UITextField!
    @IBOutlet weak var changableView: BaseGradientView!
    @IBOutlet weak var changableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: RecipieIngredientCellDelegate?
    var ingredient: IngredientCellModel?
    var indexPath: IndexPath?
    var dropDownType: IngredientDropDownType = .none
    var isValid: Bool {
        self.ingredient?.isValid() ?? false
    }
    private var units: [UnitType]?
    private var touchedSections: Set<IngredientDropDownType> {
        set {
            self.ingredient?.touchedSections = newValue
        }
        get {
            return self.ingredient?.touchedSections ?? []
        }
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    func configure(with ingredient: IngredientCellModel, units: [UnitType], indexPath: IndexPath, delegate: RecipieIngredientCellDelegate?) {
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.semanticContentAttribute = .forceRightToLeft
        
        self.units = units
        self.indexPath = indexPath
        self.delegate = delegate
        self.ingredient = ingredient
        self.dropDownType = ingredient.currentDropDownType
        
//        self.setupGestures()
        self.setupUI()
    }
    
    private func setupUI() {
        self.setupDropDown()
        
        self.fractionTopAmountTextField.delegate = self
        self.fractionBottomAmountTextField.delegate = self
        self.amountNumberTextField.delegate = self
        
        self.fractionTopAmountTextField.tintColor = .white
        self.fractionTopAmountTextField.attributedPlaceholder = NSAttributedString(string: "מונה", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.9)])
        self.fractionBottomAmountTextField.tintColor = .white
        self.fractionBottomAmountTextField.attributedPlaceholder = NSAttributedString(string: "מכנה", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.9)])
        self.amountNumberTextField.tintColor = .white
        self.amountNumberTextField.attributedPlaceholder = NSAttributedString(string: "שלם", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.9)])
        
        self.productTextField.resignFirstResponder()
        self.productTextField.textColor = .darkBlue
        self.productTextField.text = self.ingredient?.ingredient.name
//        self.amountTextField.attributedText = self.ingredient?.ingredient.amount?.fraction.asAttributedString()
        if let amountText = self.ingredient?.ingredient.amount?.fraction.asAttributedString() {
            self.amountButton.setTitleColor(.topBlue, for: .normal)
            self.amountButton.setAttributedTitle(amountText, for: .normal)
        } else {
            self.amountButton.setTitleColor(self.touchedSections.contains(.amout) ? .errorRed : .topBlue, for: .normal)
            self.amountButton.setAttributedTitle(NSAttributedString(string: "כמות"), for: .normal)
        }
        
        let numberValue = self.ingredient?.ingredient.amount?.fraction.value
        let topValue = self.ingredient?.ingredient.amount?.fraction.topValue
        let bottomValue = self.ingredient?.ingredient.amount?.fraction.bottomValue
        self.amountNumberTextField.text = numberValue != nil ? String(numberValue ?? 0) : ""
        self.fractionTopAmountTextField.text = topValue != nil ? String(topValue ?? 0) : ""
        self.fractionBottomAmountTextField.text = bottomValue != nil ? String(bottomValue ?? 0) : ""
        
        self.unitsButton.setTitle(self.ingredient?.ingredient.unit?.description(for: self.ingredient?.ingredient.amount?.decimal.number) ?? "יחידת מידה", for: .normal)
        self.ingredient?.ingredient.name?.isEmpty ?? true && self.touchedSections.contains(.none) ? self.productTextField.setError() : self.productTextField.removeError()
        self.ingredient?.ingredient.unit == nil && self.touchedSections.contains(.units) ? self.unitsButton.setTitleColor(.errorRed, for: .normal) : self.unitsButton.setTitleColor(.topBlue, for: .normal)
        self.ingredient?.ingredient.unit == nil && self.touchedSections.contains(.units) ? self.unitsButton.setTitleColor(.errorRed, for: .normal) : self.unitsButton.setTitleColor(.topBlue, for: .normal)
//        self.ingredient?.ingredient.amount?.isValid() ?? false || !self.touchedSections.contains(.amout) ? self.amountTextField.removeError() : self.amountTextField.setError()
    }
    
//    @objc func onAmountPressed() {
//        self.reloadData(with: self.dropDownType == .amout ? .none : .amout)
//    }
    
    @IBAction func onProductTextField(_ sender: UITextField) {
        if self.dropDownType == .none { return }
        self.reloadData(with: .none)
    }
    
    @IBAction func onUnitPressed(_ sender: UIButton) {
        self.reloadData(with: self.dropDownType == .units ? .none : .units)
    }
    
    @IBAction func onAmountPressed(_ sender: UIButton) {
        self.reloadData(with: self.dropDownType == .amout ? .none : .amout)
    }
    
    @IBAction func onDeletePressed(_ sender: UIButton) {
        guard let indexPath = self.indexPath else { return }
        self.delegate?.deleteItem(at: indexPath)
    }
    
    private func setupDropDown() {
        switch self.dropDownType {
        case .amout:
            self.amountView.isHidden = false
            self.amountTopImageView.isHidden = false
            self.unitsView.isHidden = true
            self.unitsTopImageView.isHidden = true
            self.changableView.isHidden = false
            self.changableViewHeight.constant = 120
        case .units:
            self.amountView.isHidden = true
            self.amountTopImageView.isHidden = true
            self.unitsView.isHidden = false
            self.unitsTopImageView.isHidden = false
            self.changableView.isHidden = false
            self.layoutIfNeeded()
            self.changableViewHeight.constant = self.collectionView.contentSize.height + 16
        case .none:
            self.amountView.isHidden = true
            self.amountTopImageView.isHidden = true
            self.unitsView.isHidden = true
            self.unitsTopImageView.isHidden = true
            self.changableView.isHidden = true
            self.changableViewHeight.constant = 0
        }
        self.layoutIfNeeded()
    }
    
//    private func setupGestures() {
//        if self.amountDisplayView.gestureRecognizers?.isEmpty ?? true {
//            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onAmountPressed))
//            self.amountDisplayView.addGestureRecognizer(tapGesture)
//        }
//    }
    
    private func reloadData(with dropDownType: IngredientDropDownType) {
        if let indexPath = self.indexPath, var ingredient = self.ingredient {
            ingredient.currentDropDownType = dropDownType
            self.delegate?.reloadItem(at: indexPath, with: ingredient)
        }
    }
    
    @IBAction func productTextHasChanged(_ sender: UITextField) {
        self.ingredient?.ingredient.name = sender.text
        self.touchedSections.insert(.none)
        self.handleErrors()
    }
    @IBAction func fractionTopAmountTextHasChanged(_ sender: UITextField) {
        self.updateAmountTextField(sender)
    }
    @IBAction func fractionBottomAmountTextHasChanged(_ sender: UITextField) {
        self.updateAmountTextField(sender)
    }
    @IBAction func amountTextHasChanged(_ sender: UITextField) {
        self.updateAmountTextField(sender)
    }
}

//MARK: AmountTextField Updates Handling
extension RecipieIngredientCell {
    
    private func updateAmountTextField(_ sender: UITextField) {
        if self.ingredient?.ingredient.amount == nil {
            self.ingredient?.ingredient.amount = Number()
        }
        switch sender {
        case self.fractionTopAmountTextField:
            self.ingredient?.ingredient.amount?.fraction.topValue = Int(sender.text ?? "")
        case self.fractionBottomAmountTextField:
            self.ingredient?.ingredient.amount?.fraction.bottomValue = Int(sender.text ?? "")
        case self.amountNumberTextField:
            self.ingredient?.ingredient.amount?.fraction.value = Int(sender.text ?? "")
        default:
            break
        }
//        self.amountTextField.attributedText = self.ingredient?.ingredient.amount?.fraction.asAttributedString()
        self.amountButton.setAttributedTitle(self.ingredient?.ingredient.amount?.fraction.asAttributedString(), for: .normal)
        self.touchedSections.insert(.amout)
        self.handleErrors()
    }
}

//MARK: UITextFieldDelegate
extension RecipieIngredientCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        (textField as? BaseUITextField)?.handleRange(range, replacementString: string) ?? true
    }
}

//MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension RecipieIngredientCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.units?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: UnitCell.self), for: indexPath) as! UnitCell
        if let unit = self.units?[safe: indexPath.row] {
            cell.configure(with: unit)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let unit = (collectionView.cellForItem(at: indexPath) as! UnitCell).type
        self.ingredient?.ingredient.unit = unit
        self.unitsButton.setTitle(unit?.description(for: self.ingredient?.ingredient.amount?.decimal.number), for: .normal)
        self.touchedSections.insert(.units)
        self.handleErrors()
        self.reloadData(with: .none)
    }
}

//MARK: Errors Handling
extension RecipieIngredientCell {
    func handleErrors(allSections: Bool = false) {
        guard let indexPath = self.indexPath, let ingredient = self.ingredient else { return }
        self.delegate?.valueHasChanged(at: indexPath, with: ingredient)
        
        var sectionToCheck: Set<IngredientDropDownType>?
        if allSections {
            sectionToCheck = Set(IngredientDropDownType.allCases)
        } else {
            sectionToCheck = self.touchedSections
        }
        
        sectionToCheck?.forEach {
            switch $0 {
            case .amout:
//                self.ingredient?.ingredient.amount?.isValid() ?? false ? self.amountTextField.removeError() : self.amountTextField.setError()
                self.amountButton.setTitleColor(self.ingredient?.ingredient.amount?.isValid() ?? false ? .topBlue : .errorRed, for: .normal)
            case .units:
                self.ingredient?.ingredient.unit == nil ? self.unitsButton.setTitleColor(.errorRed, for: .normal) : self.unitsButton.setTitleColor(.topBlue, for: .normal)
            case .none:
                self.ingredient?.ingredient.name?.isEmpty ?? true ? self.productTextField.setError() : self.productTextField.removeError()
            }
        }
    }
}
