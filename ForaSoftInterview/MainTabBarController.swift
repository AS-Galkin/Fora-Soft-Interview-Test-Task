//
//  MainTabBarController.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 25.10.2021.
//

import UIKit
import Alamofire

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundColor = .gray
        let serchVC = SearchViewController()
        serchVC.navigationItem.title = "Search"
        let navVcC = UINavigationController(rootViewController: serchVC)
        navVcC.navigationBar.prefersLargeTitles = true
        navVcC.navigationBar.backgroundColor = .gray
        navVcC.tabBarItem.title = "Search"
        self.viewControllers = [navVcC]
    }
}
