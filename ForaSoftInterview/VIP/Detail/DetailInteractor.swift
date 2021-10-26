//
//  DetailInteractor.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 26.10.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Alamofire

protocol DetailBusinessLogic {
    func makeRequest(request: Detail.Model.Request.RequestType)
}

class DetailInteractor: DetailBusinessLogic {
    
    var presenter: DetailPresentationLogic?
    private var network: NetworkLayer = NetworkLayer()
    
    func makeRequest(request: Detail.Model.Request.RequestType) {
        switch request {
        case .getTacks(let lookup):
            network.fetchResult(url: .lookupApiURL, limit: 30, searchText: lookup, entity: .song,completion: {[weak self] (searchResult: SearchResponse<Track>?, error: AFError?) -> Void in
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
