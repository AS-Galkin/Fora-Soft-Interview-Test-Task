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
  
  func presentData(response: History.Model.Response.ResponseType) {

      switch response {
      case .presentHistory(let response):
          viewController?.displayData(viewModel: .displayHistory(HistoryViewModel.init(terms: response)))
          break
      @unknown default:
          break
      }
  }
  
}
