//
//  SearchView.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 18/01/2021.
//

import UIKit

protocol SearchViewDelegate {
    func search(_ text: String?)
}

class SearchView: UIView, XibInstantiable {
    
    @IBOutlet weak var searchRoundedView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var delegate: SearchViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.xibinstantiate())
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addSubview(self.xibinstantiate())
        self.setup()
    }
    
    private func setup() {
        self.searchRoundedView.fullyRound(diameter: 20)
        self.searchTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    @objc func editingChanged(_ sender: UITextField) {
        self.delegate?.search(sender.text)
    }
    
    @IBAction func onClose(_ sender: UIButton) {
        self.searchTextField.text = nil
        self.delegate?.search(nil)
    }
}
