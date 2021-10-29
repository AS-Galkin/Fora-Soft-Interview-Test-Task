//
//  SearchInteractor.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 25.10.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Alamofire

protocol SearchBusinessLogic {
    func makeRequest(request: Search.Model.Request.RequestType)
}

/*
 # Controller that interact with external services.
 */
class SearchInteractor: SearchBusinessLogic {
    //MARK: - Variables
    /// Controller for preapring Data to displaying
    var presenter: SearchPresentationLogic?
    
    private var network = NetworkLayer()
    
    //MARK: - Making Request
    /**
     Making request depending on the *RequestType*.
     */
    func makeRequest(request: Search.Model.Request.RequestType) {
        switch request {
            /// Geting albums depending on searching.
        case .getAlbums(let searchTerm):
            /// Says presenter to present Loading Process
            self.presenter?.presentData(response: .presentActivityIndicator)
            
            /// Fetch albums with limit 30 in *SearchResponse<Album>?* structure.
            network.fetchResult(url: .searchApiURL, limit: 30, searchText: searchTerm,
                                completion: { [weak self] (searchResult: SearchResponse<Album>?, error: AFError?) -> Void in
                
                /// If we get albums
                if let searchResult = searchResult {
                    /// Says presenter to prepare Searched Data
                    self?.presenter?.presentData(response: .prepareResponse(responseTerm: searchResult))
                    /// Says presenter to stop present Loading Process
                    self?.presenter?.presentData(response: .removeActivityIndicator)
                }
            })
            /// Saving searched text to UserDefaults
        case .saveTerm(let searchTerm):
            saveSearch(for: searchTerm, saver: UserDefaultsLayer.shared)
            break
        @unknown default:
            break
        }
    }
    
    /**
     Saving searched text to UserDefaults
     */
    private func saveSearch(for query: String, saver: HistoryDataProtocol) {
        saver.saveSearchQuery(for: query)
    }
}
