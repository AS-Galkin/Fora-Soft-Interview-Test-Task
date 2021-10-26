//
//  DetailPresenter.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 26.10.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol DetailPresentationLogic {
  func presentData(response: Detail.Model.Response.ResponseType)
}

class DetailPresenter: DetailPresentationLogic {
  weak var viewController: DetailDisplayLogic?
  
  func presentData(response: Detail.Model.Response.ResponseType) {
  
  }
  
}
