//
//  SearchRouter.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 25.10.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchRoutingLogic: AnyObject {
    func routeToDetailViewController(idCollection: Int)
    func routeFromHistoryViewController(searchTerm: String)
}

class SearchRouter: NSObject, SearchRoutingLogic {

    weak var viewController: SearchViewController?
    
    // MARK: Routing
    func routeToDetailViewController(idCollection: Int) {
        viewController?.navigationController?.pushViewController(AlbumTracksViewController(collectionId: idCollection), animated: true)
    }
    
    func routeFromHistoryViewController(searchTerm: String) {
        guard let searchBar = viewController?.searchController?.searchBar else { return }
        searchBar.text = searchTerm
        viewController?.searchBar(searchBar, textDidChange: searchTerm)
    }
    
}
