//
//  ConvertRecipeViewController.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 06/01/2021.
//

import UIKit

class ConvertRecipeViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var originalNumberTextField: UITextField!
    @IBOutlet weak var convertedNumberTextField: UITextField!
    @IBOutlet weak var convertView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var convertViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var changeGlassButton: UIButton!
    @IBOutlet weak var hintView: UIView!
    
    var recipe: Recipe?
    private var ingredients: [Ingredient] {
        self.recipe?.ingredients ?? []
    }
    private var multiplier: Double = 1
    private var convertViewOriginY: CGFloat?
    private var numOfOutcomes: Int?
    
    lazy var sliderBackgroundView: BaseGradientView = {
        let view = BaseGradientView()
        view.backgroundView.backgroundColor = UIColor.topBlue.withAlphaComponent(0.2)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slider.addTarget(self, action: #selector(sliderWasDragged), for: .touchDragInside)
        slider.addTarget(self, action: #selector(sliderWasDragged), for: .touchDragOutside)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = false
    }

    func setupUI() {
        self.originalNumberTextField.delegate = self
        self.convertedNumberTextField.delegate = self
        self.convertedNumberTextField.addTarget(self, action: #selector(convertedNumberEditingDidBegin), for: .editingDidBegin)
        self.tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        self.slider.setThumbImage(UIImage(named: "slider"), for: .normal)
        self.slider.setThumbImage(UIImage(named: "slider"), for: .focused)
        self.slider.setThumbImage(UIImage(named: "slider"), for: .highlighted)
        self.slider.setThumbImage(UIImage(named: "slider"), for: .selected)
        self.changeGlassButton.isHidden = !(self.ingredients.contains{ $0.isConvetable() } && SessionManager.shared.isConvertionEnabled ?? false)
        if let numOfOutcomes = self.recipe?.numOfOutcomes {
            self.numOfOutcomes = numOfOutcomes
            self.tableView.alpha = 1
            self.hintView.isHidden = true
            self.slider.isEnabled = self.numOfOutcomes.isNotZero
            self.slider.maximumValue = Float(numOfOutcomes * 2)
            self.slider.value = Float(numOfOutcomes)
            self.originalNumberTextField.text = String(numOfOutcomes)
        } else {
            self.tableView.alpha = 0.3
            self.hintView.isHidden = false
        }
        self.convertedNumberTextField.isEnabled = self.recipe?.numOfOutcomes != nil
        self.sliderBackgroundView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width / 2, height: self.view.frame.height)
        self.view.addSubview(self.sliderBackgroundView)
        self.view.sendSubviewToBack(self.sliderBackgroundView)
    }
    
    @objc func sliderWasDragged(_ sender: UISlider) {
        if sender.value == sender.maximumValue {
            UIView.animate(withDuration: 0.15) { [unowned self] in
                self.sliderBackgroundView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            }
        } else if sender.value == sender.minimumValue {
            UIView.animate(withDuration: 0.15) { [unowned self] in
                self.sliderBackgroundView.frame = CGRect(x: 0, y: 0, width: 0, height: self.view.frame.height)
            }
        } else {
            self.sliderBackgroundView.frame = CGRect(x: 0, y: 0, width: sender.thumbCenterX, height: self.view.frame.height)
        }
    }
    
    @IBAction func sliderValueHasChanged(_ sender: UISlider) {
        let number = Decimal(number: Double(sender.value))
        let numberToHalf = number.asFractionNearestHalf()
        self.convertedNumberTextField.attributedText = sender.value != 0 && numberToHalf.asDecimal().number >= 0.5 ? numberToHalf.asAttributedString() : NSAttributedString(string: "0")
        self.sliderWasDragged(sender)
        
        let multiplier = Double(self.slider.value).roundToNearestHalf() / (Double(self.originalNumberTextField.text ?? "") ?? 1).roundToNearestHalf()
        if self.multiplier != multiplier {
            self.multiplier = multiplier
            self.tableView.reloadData()
        }
    }
    
    @IBAction func convertedNumberTextFieldHasChanged(_ sender: UITextField) {
        if sender.text?.contains("\\") ?? false {
            let textSplited = sender.text?.split(separator: " ")
            if textSplited?.count == 1 {
                self.convertedNumberTextField.text = textSplited?.first?.replacingOccurrences(of: "\\", with: "").trimWhiteSpaces()
            } else {
                self.convertedNumberTextField.text = String(sender.text?.split(separator: " ").first ?? "").trimWhiteSpaces()
            }
        }
        let number = Float(self.convertedNumberTextField.text?.trimWhiteSpaces() ?? "0") ?? 0
        if number > self.slider.maximumValue || number > (Float(self.originalNumberTextField.text ?? "") ?? 1000000) * 2 {
            self.slider.maximumValue = number
        }
        self.slider.value = number
        self.sliderWasDragged(self.slider)
        
        let multiplier = Double(self.slider.value).roundToNearestHalf() / (Double(self.originalNumberTextField.text ?? "") ?? 1)
        if self.multiplier != multiplier {
            self.multiplier = multiplier
            self.tableView.reloadData()
        }
    }
    
    @IBAction func originalNumberTextFieldHasChanged(_ sender: UITextField) {
        self.slider.isEnabled = !(sender.text?.isEmpty ?? true)
        self.hintView.isHidden = true
        self.convertedNumberTextField.isEnabled = self.slider.isEnabled
        let number = Float(sender.text?.trimWhiteSpaces() ?? "0") ?? 0
        self.slider.maximumValue = (number * 2) != 0 ? number * 2 : 1
        self.slider.value = number
        self.numOfOutcomes = Int(number)
        self.sliderWasDragged(self.slider)
    }
    
    @IBAction func onChangeGlassSize(_ sender: UIButton) {
        self.showGlassSizeAlert { isChanged in
            if isChanged {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func onSavePressed(_ sender: UIButton) {
        self.recipe?.numOfOutcomes = self.numOfOutcomes
        self.showAddRecipeDetailsAlert(with: self.recipe?.name, image: self.recipe?.image) { (name, image, shouldSave) in
            guard let name = name else { return }
            self.recipe?.name = name
            if let image = image {
                self.recipe?.image = image
            }
            if shouldSave {
                self.recipe?.save() {
                    if let addRecipeDetailsAlert = UIApplication.topViewController() as? AddRecipeDetailsViewController {
                        addRecipeDetailsAlert.dismiss(animated: true) { [weak self] in
                            self?.navigationController?.popToRootViewController(animated: true)
                        }
                    } else {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
        }
    }
    
    @IBAction func onBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func resetConvertedValue() {
        if self.originalNumberTextField.text?.isEmpty ?? true {
            self.convertedNumberTextField.text = ""
            self.sliderWasDragged(self.slider)
            self.multiplier = 1
            self.tableView.reloadData()
        }
    }
}

//MARK: UITableViewDataSource + UITableViewDelegate
extension ConvertRecipeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ConvertedCell.self), for: indexPath) as! ConvertedCell
        cell.contentView.alpha = 1
        if let ingredient = self.ingredients[safe: indexPath.row] {
            cell.configure(with: ingredient, multiplier: self.multiplier)
        }
        return cell
    }
}

//MARK: UITextFieldDelegate
extension ConvertRecipeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return (textField as? BaseUITextField)?.handleRange(range, replacementString: string) ?? true
    }
    
    @objc func convertedNumberEditingDidBegin(_ textField: UITextField) {
        let text = textField.text?.replacingOccurrences(of: " 1\\2", with: "").trimWhiteSpaces() ?? ""
        textField.attributedText = NSAttributedString(string: text)
    }
}

//MARK: Keyboard Handling
extension ConvertRecipeViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            if self.convertViewBottomConstraint.constant != keyboardSize.height {
                self.convertView.alpha = 0.6
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.tableView.alpha = 0.4
                    self?.hintView.isHidden = true
                }
                UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.3, options: .showHideTransitionViews) { [weak self] in
                    self?.convertView.alpha = 1
                    self?.convertViewBottomConstraint.constant = keyboardSize.height
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        self.resetConvertedValue()
        if self.convertViewBottomConstraint.constant != 0 {
            self.convertView.alpha = 0.6
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.tableView.alpha = self?.slider.isEnabled ?? true ? 1 : 0.3
                self?.hintView.isHidden = self?.slider.isEnabled ?? true
            }
            UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.3, options: .showHideTransitionViews) { [weak self] in
                self?.convertView.alpha = 1
                self?.convertViewBottomConstraint.constant = 0
            }
        }
    }
}
