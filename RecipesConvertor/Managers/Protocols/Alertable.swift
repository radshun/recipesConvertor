//
//  Alertable.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 17/01/2021.
//

import UIKit

protocol Alertable {
    typealias CompletionHandler = ((_ isOkayAction: Bool) -> ())
    func displaySimpleAlert(with title: String?, message: String?, completion: CompletionHandler?)
}

extension BaseViewController: Alertable {
    
    func displaySimpleAlert(with title: String? = nil, message: String? = nil, completion: CompletionHandler?) {
        self.displayAlert(with: title, message: message, okayTitle: "אישור", completion: completion)
    }
    
    func displayAlert(with title: String? = nil, message: String? = nil, okayTitle: String?, completion: CompletionHandler?) {
        self.displayBaseAlert(with: title, message: message, style: .alert, okayTitle: okayTitle, completion: completion)
    }
    
    func displaySheetAlert(with title: String? = nil, message: String? = nil, customActions: [UIAlertAction]? = nil, completion: CompletionHandler?) {
        self.displayBaseAlert(with: title, message: message, style: .actionSheet, customActions: customActions, completion: completion)
    }
    
    private func displayBaseAlert(with title: String? = nil, message: String? = nil, style: UIAlertController.Style, okayTitle: String? = nil, customActions: [UIAlertAction]? = nil, completion: CompletionHandler?) {

        DispatchQueue.main.async {
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
            
            if !(customActions?.isEmpty ?? true) {
                customActions?.forEach {
                    alertController.addAction($0)
                }
            } else {
                let alertOkAction = UIAlertAction(title: okayTitle, style: .default) { (action) in
                    guard let completion = completion else { return }
                    completion(true)
                }
                alertController.addAction(alertOkAction)
            }
            
            let alertCancelAction = UIAlertAction(title: "ביטול", style: .cancel) { (action) in
                guard let completion = completion else { return }
                completion(false)
            }
            alertController.addAction(alertCancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
