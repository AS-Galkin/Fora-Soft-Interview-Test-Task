//
//  HistoryInteractor.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 26.10.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Alamofire

protocol HistoryBusinessLogic {
    func makeRequest(request: History.Model.Request.RequestType)
}

class HistoryInteractor: HistoryBusinessLogic {
    
    var presenter: HistoryPresentationLogic?
    let network: NetworkLayer = NetworkLayer()
    
    func makeRequest(request: History.Model.Request.RequestType) {
        switch request {
        case .loadHistory:
            loadHistory(loader: UserDefaultsLayer.shared) { [weak self] history in
                self?.presenter?.presentData(response: .presentHistory(response: history))
            }
            break
        @unknown default:
            break
        }
    }
    
    private func loadHistory(loader: HistoryDataProtocol, closure: @escaping ([String]) -> Void) {
        loader.loadHistory(closure: closure)
    }
}
