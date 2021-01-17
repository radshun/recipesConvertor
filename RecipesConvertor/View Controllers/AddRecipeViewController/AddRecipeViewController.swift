//
//  AddRecipeViewController.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 06/01/2021.
//

import UIKit

class AddRecipeViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var continueView: UIView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var continueImageView: UIImageView!
    
    private var ingredients: [IngredientCellModel] = []
    private var units: [UnitType] = SessionManager.shared.units
    private var isValidData: Bool = false
    private var timer: Timer?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ingredients = [IngredientCellModel()]
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.setupUI()
        self.fetchGeneralDetails()
    }
    
    func setupUI() {
        self.tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
    }
    
    @IBAction func onAddRow(_ sender: UIButton) {
        self.ingredients.append(IngredientCellModel())
        self.tableView.reloadData()
        self.hideAllDropDowns()
        self.tableView.scrollToBottom()
    }
    
    @IBAction func onContinue(_ sender: UITapGestureRecognizer) {
        self.hideAllDropDowns()
        self.goToNextScreen()
    }
    
    @IBAction func onBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddRecipeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RecipieIngredientCell.self), for: indexPath) as! RecipieIngredientCell
        if let ingredient = self.ingredients[safe: indexPath.row] {
            cell.configure(with: ingredient, units: self.units, indexPath: indexPath, delegate: self)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return AddRowView()
    }
}

extension AddRecipeViewController {
    
    private func goToNextScreen() {
        self.isDataValid { isValid in
            if isValid {
                self.proceedToConvertRecipe()
            }
        }
    }
    
    private func isDataValid(completion: @escaping (Bool) -> ()) {
        DispatchQueue.main.async { [unowned self] in
            if self.ingredients.isEmpty || self.ingredients.contains(where: { !$0.isValid() }) {
                self.isValidData = false
                self.ingredients.enumerated().forEach{ self.ingredients[$0.offset].setAllTouched() }
                self.tableView.reloadData()
            } else {
                self.isValidData = true
            }
            self.updateContinueBotton()
            completion(self.isValidData)
        }
    }
    
    private func proceedToConvertRecipe() {
        if SessionManager.shared.generalDetails != nil || SessionManager.shared.isConvertionEnabled == false {
            self.showConvertRecipe(with: self.ingredients.map{ $0.ingredient })
        } else {
            self.waitForResponse()
        }
    }
    
    private func waitForResponse() {
        timer = Timer(timeInterval: 0.3, target: self, selector: #selector(checkIfDataRecieved), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    @objc func checkIfDataRecieved() {
        if SessionManager.shared.isConvertionEnabled != nil {
            timer?.invalidate()
            self.showConvertRecipe(with: self.ingredients.map{ $0.ingredient })
        }
    }
    
    private func updateContinueBotton() {
        DispatchQueue.main.async { [unowned self] in
            if self.isValidData {
                if self.continueView.isHidden {
                    self.continueView.isHidden = false
                }
                if !self.errorView.isHidden {
                    self.errorView.isHidden = true
                }
            } else {
                if !self.continueView.isHidden {
                    self.continueView.isHidden = true
                }
                if self.errorView.isHidden {
                    self.errorView.isHidden = false
                }
            }
        }
    }
}

extension AddRecipeViewController {
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    @objc private func keyboardWillHide(notification: NSNotification) {
        self.tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
    }
}

extension AddRecipeViewController: RecipieIngredientCellDelegate {
    func reloadItem(at indexPath: IndexPath, with ingredient: IngredientCellModel) {
        self.ingredients[indexPath.row] = ingredient
        var indexesToReload: [IndexPath] = [indexPath]
        self.tableView.visibleCells.forEach {
            if let index = ($0 as? RecipieIngredientCell)?.indexPath, index != indexPath && ($0 as? RecipieIngredientCell)?.dropDownType != IngredientDropDownType.none {
                self.ingredients[index.row].currentDropDownType = .none
                indexesToReload.append(index)
            }
        }
        self.tableView.reloadRows(at: indexesToReload, with: .automatic)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    func valueHasChanged(at indexPath: IndexPath, with ingredient: IngredientCellModel) {
        self.ingredients[indexPath.row] = ingredient
        if self.continueView.isHidden {
            self.continueView.isHidden = false
        }
        if !self.errorView.isHidden {
            self.errorView.isHidden = true
        }
    }
    
    func deleteItem(at indexPath: IndexPath) {
        self.ingredients.remove(at: indexPath.row)
        self.tableView.reloadData()
    }
    
    private func hideAllDropDowns() {
        var indexesToReload: [IndexPath] = []
        self.tableView.visibleCells.forEach {
            if let index = ($0 as? RecipieIngredientCell)?.indexPath, ($0 as? RecipieIngredientCell)?.dropDownType != IngredientDropDownType.none {
                self.ingredients[index.row].currentDropDownType = .none
                indexesToReload.append(index)
            }
        }
        self.tableView.reloadRows(at: indexesToReload, with: .automatic)
    }
}

//MARK: Requests
extension AddRecipeViewController {
    func fetchGeneralDetails() {
        if SessionManager.shared.generalDetails == nil {
            SessionManager.shared.isConvertionEnabled = nil
            self.showLoadingAnimation()
            GeneralService().fetchGeneralData { response in
                switch response {
                case .success(let generalData):
                    SessionManager.shared.isConvertionEnabled = true
                    SessionManager.shared.generalDetails = generalData
                    self.removeLoadingAnimation()
                case .failure(_):
                    SessionManager.shared.isConvertionEnabled = false
                    self.removeLoadingAnimation()
                }
            }
        }
    }
}

//MARK: Loading Animations
extension AddRecipeViewController {
    private func showLoadingAnimation() {
        DispatchQueue.main.async { [unowned self] in
            self.continueImageView.image = UIImage.gif(asset: "loading")
        }
    }
    
    private func removeLoadingAnimation() {
        DispatchQueue.main.async { [unowned self] in
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.continueImageView.alpha = 0
            } completion: { _ in
                self.continueImageView.image = UIImage(named: "checkmark")
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.continueImageView.alpha = 1
                }
            }
        }
    }
}
