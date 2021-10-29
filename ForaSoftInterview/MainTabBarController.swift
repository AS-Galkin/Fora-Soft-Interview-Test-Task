//
//  MainTabBarController.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 25.10.2021.
//

import UIKit
import Alamofire

/*
 ## Main TabBarController. That contains main navigation between VeiwController in App.
 */

class MainTabBarController: UITabBarController {
    /// ViewController, that displaying searching Albums in CollectionView
    let searchVC = SearchViewController()
    /// ViewController that diplaying User search history in tableView
    let historyVC = HistoryViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHistoryDelegate()
        self.tabBar.backgroundColor = .tabAndNavBarColor
        
        self.viewControllers = [
            generateVC(rootViewController: searchVC, title: "Search", image: #imageLiteral(resourceName: "search")),
            generateVC(rootViewController: historyVC, title: "History", image: #imageLiteral(resourceName: "history"))
        ]
        self.tabBar.tintColor = #colorLiteral(red: 0.9369474649, green: 0.3679848909, blue: 0.426604867, alpha: 1)
    }
    
    /// Method that setting SearchRouter  as Delegete in HistoryViewController
    private func setupHistoryDelegate() {
        if let historyRouter = historyVC.router as? HistoryRouter {
            historyRouter.searchDelegate = searchVC.router.self
        }
    }
    
    /**
     Covering ViewController into NavigationController
     - returns:
     UINavigationController with some root ViewController.
     - parameters:
        - rootViewController: ViewController that need to cover.
        - title: Title of navigationItem
        - image: Image that will displaying in tabBarItem
     */
    private func generateVC(rootViewController: UIViewController, title: String, image: UIImage) -> UINavigationController {
        let navVC = UINavigationController(rootViewController: rootViewController)
        rootViewController.navigationItem.title = title
        navVC.navigationBar.prefersLargeTitles = true
        navVC.navigationBar.backgroundColor = .systemBackground
        navVC.tabBarItem.image = image
        return navVC
    }
}
