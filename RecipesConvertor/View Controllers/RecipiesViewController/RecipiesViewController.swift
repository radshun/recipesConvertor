//
//  ViewController.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 03/01/2021.
//

import UIKit

enum SearchState {
    case opened
    case closed
}

class RecipiesViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchView: SearchView!
    @IBOutlet weak var searchButton: UIButton!
    
    private var initialRecipies: [Recipe] = []
    private var recipies: [Recipe] = []
    private var selectedImageIndex: IndexPath?
    private var searchState: SearchState = .closed
    private lazy var imageUploadManager: ImageUploadManager? = {
        ImageUploadManager(delegate: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fetchData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.setupSearchUI(with: .closed)
    }

    private func setupTableView() {
        self.tableView.rowHeight = 100
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    private func fetchData() {
        SessionManager.shared.fetchRecipes { recipies in
            self.initialRecipies = recipies
            self.recipies = recipies
            self.searchButton.isHidden = recipies.count <= 6 || self.searchState == .opened
            self.tableView.reloadData()
        }
    }
    
    private func setupUI() {
        self.searchView.delegate = self
    }
    
    @IBAction func onSearchPressed(_ sender: UIButton) {
        self.setupSearchUI(with: .opened)
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
        cell.configure(with: recipies[indexPath.row], indexPath: indexPath, delegate: self)
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
                    if let index = self.initialRecipies.firstIndex(where: { $0.id == recipe.id }) {
                        self.initialRecipies.remove(at: index)
                    }
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

//MARK: RecipieCellDelegate
extension RecipiesViewController: RecipieCellDelegate {
    
    func addImagePressed(in indexPath: IndexPath) {
        self.selectedImageIndex = indexPath
        self.imageUploadManager?.showOptions()
    }
}

//MARK: ImageUploadManagerDelegate
extension RecipiesViewController: ImageUploadManagerDelegate {
    
    func imageWasPicked(image: UIImage?) {
        guard let image = image, let indexPath = self.selectedImageIndex,
              var recipe = self.recipies[safe: indexPath.row] else { return }
        recipe.image = image
        self.recipies.remove(at: indexPath.row)
        self.recipies.insert(recipe, at: indexPath.row)
        if let index = self.initialRecipies.firstIndex(where: { $0.id == recipe.id }) {
            self.initialRecipies.remove(at: index)
            self.initialRecipies.insert(recipe, at: index)
        }
        SessionManager.shared.addRecipe(recipe)
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
        self.selectedImageIndex = nil
    }
}

//MARK: Search Handling
extension RecipiesViewController: SearchViewDelegate {
    
    func search(_ text: String?) {
        if let text = text, !text.isEmpty {
            self.recipies = self.recipies.filter{ $0.name?.contains(text) ?? false }
        } else {
            self.recipies = self.initialRecipies
        }
        self.tableView.reloadData()
    }
    
    private func setupSearchUI(with state: SearchState) {
        self.searchState = state
        UIView.animate(withDuration: 0.3) { [weak self] in
            switch state {
            case .opened:
                self?.titleLabel.isHidden = true
                self?.searchButton.isHidden = true
                self?.searchView.isHidden = false
            case .closed:
                self?.titleLabel.isHidden = false
                self?.searchButton.isHidden = false
                self?.searchView.isHidden = true
            }
        }
    }
}
