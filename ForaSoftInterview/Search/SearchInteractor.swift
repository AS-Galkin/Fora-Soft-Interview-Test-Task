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
    var service: SearchService?
    private var network = NetworkLayer()
    func makeRequest(request: Search.Model.Request.RequestType) {
        if service == nil {
            service = SearchService()
        }
        
        switch request {
        case .getAlbums(let searchTerm):
            network.fetchResult(url: .searchApiURL, limit: 2, searchText: searchTerm,
                                completion: {(searchResult: SearchResponse<Album>?, error: AFError?) -> Void in
                if let searchResult = searchResult {
                    print(searchResult)
                }
            })
        @unknown default:
            break
        }
    }
    
}
