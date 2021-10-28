//
//  HistoryRouter.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 26.10.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol HistoryRoutingLogic: AnyObject {
    func routeToSearchViewController(searchTerm: String)
}

class HistoryRouter: NSObject, HistoryRoutingLogic {
    
    weak var viewController: HistoryViewController?
    weak var searchDelegate: SearchRoutingLogic?
    
    // MARK: Routing
    
    func routeToSearchViewController(searchTerm: String) {
        viewController?.tabBarController?.selectedIndex = 0
        searchDelegate?.routeFromHistoryViewController(searchTerm: searchTerm)
    }
}
