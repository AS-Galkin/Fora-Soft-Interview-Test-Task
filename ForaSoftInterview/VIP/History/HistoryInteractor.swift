//
//  HistoryInteractor.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 26.10.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol HistoryBusinessLogic {
  func makeRequest(request: History.Model.Request.RequestType)
}

class HistoryInteractor: HistoryBusinessLogic {

  var presenter: HistoryPresentationLogic?
  var service: HistoryService?
  
  func makeRequest(request: History.Model.Request.RequestType) {
    if service == nil {
      service = HistoryService()
    }
  }
  
}
