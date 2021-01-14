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
    
    var recipies: [String] = ["עוגת גבינה","עוגיות שוקולד ציפס"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.setupUI()
    }

    func setupTableView() {
        self.tableView.rowHeight = 100
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func setupUI() {
        
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
}

//MARK: Navigation
extension RecipiesViewController {
    private func showAddRecipe(with recipe: String? = nil) {
        let addRecipeViewController = AddRecipeViewController.instantiateFrom(storyboard: .main)
        addRecipeViewController.modalPresentationStyle = .fullScreen
        self.show(addRecipeViewController, sender: nil)
    }
}
