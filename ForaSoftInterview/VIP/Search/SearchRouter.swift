//
//  SearchRouter.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 25.10.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchRoutingLogic {
    func routeToDetailViewController(idCollection: Int)
}

class SearchRouter: NSObject, SearchRoutingLogic {
    
    weak var viewController: SearchViewController?
    
    // MARK: Routing
    func routeToDetailViewController(idCollection: Int) {
        let detailVC = TrackViewController()
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
