//
//  HistoryPresenter.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 26.10.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol HistoryPresentationLogic {
  func presentData(response: History.Model.Response.ResponseType)
}

class HistoryPresenter: HistoryPresentationLogic {
  weak var viewController: HistoryDisplayLogic?
  
    //MARK: - Preparation data for displaying
    /**
     Prepare data reached from interactor and send it to ViewController. Present making depending on *ResponseType*.
     */
  func presentData(response: History.Model.Response.ResponseType) {
      switch response {
          /// Prepare and send data to viewController
      case .prepareHistory(let response):
          /// Send prepared data
          viewController?.displayData(viewModel: .displayHistory(HistoryViewModel.init(terms: response)))
          break
      @unknown default:
          break
      }
  }
  
}
