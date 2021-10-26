//
//  MainTabBarController.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 25.10.2021.
//

import UIKit
import Alamofire

class MainTabBarController: UITabBarController {
    let searchVC = SearchViewController()
    let historyVC = HistoryViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundColor = .tabAndNavBarColor
        self.viewControllers = [
            generateVC(rootViewController: searchVC, title: "Search", image: #imageLiteral(resourceName: "search")),
            generateVC(rootViewController: historyVC, title: "History", image: #imageLiteral(resourceName: "search"))
        ]
        self.tabBar.tintColor = #colorLiteral(red: 0.9369474649, green: 0.3679848909, blue: 0.426604867, alpha: 1)
    }
    
    private func generateVC(rootViewController: UIViewController, title: String, image: UIImage) -> UINavigationController {
        let navVC = UINavigationController(rootViewController: rootViewController)
        rootViewController.navigationItem.title = title
        navVC.navigationBar.prefersLargeTitles = true
        navVC.navigationBar.backgroundColor = .systemBackground
        navVC.tabBarItem.title = title
        navVC.tabBarItem.image = image
        return navVC
    }
}
