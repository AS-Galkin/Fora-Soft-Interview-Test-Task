//
//  UIViewController + Storyboard.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 25.10.2021.
//

import UIKit

extension UIViewController {
    class func loadFromStoryboard<T: UIViewController>() -> T {
        let name = String(describing: T.self)
        let storyboard = UIStoryboard(name: name, bundle: nil)
        
        if let vc = storyboard.instantiateInitialViewController() as? T {
            return vc
        } else {
            fatalError("Error: No initial viewController in \(name) storyboard!")
        }
    }
}
