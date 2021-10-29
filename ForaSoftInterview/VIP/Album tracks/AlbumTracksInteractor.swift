//
//  AlbumTracksInteractor.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 26.10.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Alamofire

protocol AlbumTracksBusinessLogic {
    func makeRequest(request: AlbumTracks.Model.Request.RequestType)
}

/*
 # Controller that interact with external services.
 */
class AlbumTracksInteractor: AlbumTracksBusinessLogic {
    //MARK: - Variables
    /// Controller for preapring Data to displaying
    var presenter: AlbumTracksPresentationLogic?
    
    private let network = NetworkLayer()
    //MARK: - Making Request
    /**
     Making request depending on the *RequestType*.
     */
    func makeRequest(request: AlbumTracks.Model.Request.RequestType) {
        switch request {
            /// Geting tracks depending on searching.
        case.getTracks(let lookup):
            /// Fetch tracks with limit 30  in *SearchResponse<Track>?* structure.
            network.fetchResult(url: .lookupApiURL, limit: 30, searchText: lookup, entity: .song) { [weak self] (searchResult: SearchResponse<Track>?, error: AFError?) -> Void in
                if let data = searchResult {
                    /// Says presenter to prepare Searched Data
                    self?.presenter?.presentData(response: .prepareTracks(response: data))
                }
            }
            break
        @unknown default:
            break
        }
    }
    
}
