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

class AlbumTracksInteractor: AlbumTracksBusinessLogic {
    
    var presenter: AlbumTracksPresentationLogic?
    private let network = NetworkLayer()
    
    func makeRequest(request: AlbumTracks.Model.Request.RequestType) {
        switch request {
        case.getTracks(let lookup):
            network.fetchResult(url: .lookupApiURL, limit: 30, searchText: lookup, entity: .song) { [weak self] (searchResult: SearchResponse<Track>?, error: AFError?) -> Void in
                if let data = searchResult {
                    self?.presenter?.presentData(response: .presentTracks(response: data))
                }
            }
            break
        @unknown default:
            break
        }
    }
    
}
