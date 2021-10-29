//
//  SearchRouter.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 25.10.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchRoutingLogic: AnyObject {
    func routeToTracksViewController(idCollection: Int)
    func routeFromHistoryViewController(searchTerm: String)
}

/*
 # Class that routing between Controllers.
 */
class SearchRouter: NSObject, SearchRoutingLogic {

    weak var viewController: SearchViewController?
    
    // MARK: - Routing
    /**
     Route to ViewController that Showing tracks of album
     */
    func routeToTracksViewController(idCollection: Int) {
        viewController?.navigationController?.pushViewController(AlbumTracksViewController(collectionId: idCollection), animated: true)
    }
    /**
     Works if HistoryViewControlles calls SearchViewController.
     Send reached parameters to SearchViewController.
     */
    func routeFromHistoryViewController(searchTerm: String) {
        guard let searchBar = viewController?.searchController?.searchBar else { return }
        searchBar.text = searchTerm
        viewController?.searchBar(searchBar, textDidChange: searchTerm)
    }
    
}
