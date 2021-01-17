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

        DispatchQueue.main.async {
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let alertCancelAction = UIAlertAction(title: "ביטול", style: .default) { (action) in
                guard let completion = completion else { return }
                completion(false)
            }
            alertController.addAction(alertCancelAction)
            
            let alertOkAction = UIAlertAction(title: "אישור", style: .default) { (action) in
                guard let completion = completion else { return }
                completion(true)
            }
            alertController.addAction(alertOkAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
