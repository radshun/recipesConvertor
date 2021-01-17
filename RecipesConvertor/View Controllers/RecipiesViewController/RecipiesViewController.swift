//
//  ViewController.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 03/01/2021.
//

import UIKit
import SwiftGifOrigin

class RecipiesViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var recipies: [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupUI()
    }

    func setupTableView() {
        self.tableView.rowHeight = 100
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    func setupUI() {
        SessionManager.shared.fetchRecipes { recipies in
            self.recipies = recipies
            self.tableView.reloadData()
        }
    }
    
    @IBAction func onAddRecipe(_ sender: UIButton) {
        self.showAddRecipe()
    }
}

extension RecipiesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RecipieCell.self), for: indexPath) as! RecipieCell
        cell.configure(with: recipies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showAddRecipe(with: recipies[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let name = self.recipies[safe: indexPath.row]?.name else { return }
        self.displaySimpleAlert(message: "האם ברצונך למחוק את המתכון \"\(name)\"?") { isApproved in
            if isApproved {
                if editingStyle == .delete {
                    let recipe = self.recipies.remove(at: indexPath.row)
                    SessionManager.shared.deleteRecipe(recipe)
                    self.tableView.beginUpdates()
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    self.tableView.endUpdates()
                }
            } else {
                self.tableView.endEditing(true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "מחיקה"
    }
}
