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
            network.fetchResult(url: .searchApiURL, limit: 2, searchText: searchTerm,
                                completion: { [weak self] (searchResult: SearchResponse<Album>?, error: AFError?) -> Void in
                if let searchResult = searchResult {
                    self?.presenter?.presentData(response: .presentAlbums(responseTerm: searchResult))
                }
            })
        case .getTracks(searchTerm: let searchTerm):
            network.fetchResult(url: .lookupApiURL, limit: 30, searchText: searchTerm, entity: .song,completion: {[weak self] (searchResult: SearchResponse<Track>?, error: AFError?) -> Void in
                if let searchResult = searchResult {
                    self?.presenter?.presentData(response: .presentTracks(responseTerm: searchResult))
                }
            })
            break
        @unknown default:
            break
        }
    }
    
}
