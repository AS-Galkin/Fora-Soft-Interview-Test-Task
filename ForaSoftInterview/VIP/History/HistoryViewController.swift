//
//  HistoryViewController.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 26.10.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol HistoryDisplayLogic: AnyObject {
  func displayData(viewModel: History.Model.ViewModel.ViewModelData)
}

class HistoryViewController: UIViewController, HistoryDisplayLogic {

  var interactor: HistoryBusinessLogic?
  var router: (NSObjectProtocol & HistoryRoutingLogic)?

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup() {
    let viewController        = self
    let interactor            = HistoryInteractor()
    let presenter             = HistoryPresenter()
    let router                = HistoryRouter()
    viewController.interactor = interactor
    viewController.router     = router
    interactor.presenter      = presenter
    presenter.viewController  = viewController
    router.viewController     = viewController
  }
  
  // MARK: Routing
  

  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func displayData(viewModel: History.Model.ViewModel.ViewModelData) {

  }
  
}
