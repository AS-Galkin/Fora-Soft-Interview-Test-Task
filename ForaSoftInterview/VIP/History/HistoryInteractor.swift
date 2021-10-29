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

/*
 # Controller that interact with external services.
 */
class HistoryInteractor: HistoryBusinessLogic {
    //MARK: - Variables
    /// Controller for preapring Data to displaying
    var presenter: HistoryPresentationLogic?
    
    let network: NetworkLayer = NetworkLayer()
    
    //MARK: - Making Request
    /**
     Making request depending on the *RequestType*.
     */
    func makeRequest(request: History.Model.Request.RequestType) {
        switch request {
            /// Geting history from UserDefaults.
        case .loadHistory:
            /// Loading history
            loadHistory(loader: UserDefaultsLayer.shared) { [weak self] history in
                /// Says *Presenter* to prepare data from UserDefaults.
                self?.presenter?.presentData(response: .prepareHistory(response: history))
            }
            break
            /// Saving history to userDefaults.
        case .saveNewHistory(history: let history):
            UserDefaultsLayer.shared.saveNewHistory(history: history.terms)
            break
        @unknown default:
            break
        }
    }
    
    /**
     Loading history from UserDefaults.
     */
    private func loadHistory(loader: HistoryDataProtocol, closure: @escaping ([String]) -> Void) {
        loader.loadHistory(closure: closure)
    }
}
