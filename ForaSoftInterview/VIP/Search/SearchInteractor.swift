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

class SearchInteractor: SearchBusinessLogic {
    
    var presenter: SearchPresentationLogic?
    private var network = NetworkLayer()
    func makeRequest(request: Search.Model.Request.RequestType) {
        switch request {
        case .getAlbums(let searchTerm):
            self.presenter?.presentData(response: .presentActivityIndicator)
            network.fetchResult(url: .searchApiURL, limit: 30, searchText: searchTerm,
                                completion: { [weak self] (searchResult: SearchResponse<Album>?, error: AFError?) -> Void in
                if let searchResult = searchResult {
                    self?.presenter?.presentData(response: .presentAlbums(responseTerm: searchResult))
                    self?.presenter?.presentData(response: .removeActivityIndicator)
                }
            })
        @unknown default:
            break
        }
    }
    
}
