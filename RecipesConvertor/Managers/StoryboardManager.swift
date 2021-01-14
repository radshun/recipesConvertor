//
//  StoryboardManager.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 06/01/2021.
//

import UIKit

enum StoryboardManager: String {
    
    // MARK: Storyboards names
    case main
    
    var storyboardInstance : UIStoryboard {
        return UIStoryboard(name: self.rawValue.capitalized, bundle: Bundle.main)
    }
    
    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
        
        let storyboardId = (viewControllerClass as UIViewController.Type).storyboardId
        return storyboardInstance.instantiateViewController(withIdentifier: storyboardId) as! T
    }
    
    func viewController<T: UIViewController>(viewControllerClass: T.Type, suffix: String) -> T {
        
        let storyboardId = (viewControllerClass as UIViewController.Type).storyboardId + suffix
        return storyboardInstance.instantiateViewController(withIdentifier: storyboardId) as! T
    }
    
    func initialViewController() -> UIViewController? {
        return storyboardInstance.instantiateInitialViewController()
    }
}

extension UIViewController {
    
    class var storyboardId: String {
        return "\(self)"
    }
    
    static func instantiateFrom(storyboard: StoryboardManager) -> Self {
        return storyboard.viewController(viewControllerClass: self)
    }
    
    static func instantiateFrom(storyboard: StoryboardManager, suffix: String) -> Self {
        return storyboard.viewController(viewControllerClass: self, suffix: suffix)
    }
}
