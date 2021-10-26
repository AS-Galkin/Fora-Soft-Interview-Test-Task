//
//  AlbumTracksViewController.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 26.10.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol AlbumTracksDisplayLogic: class {
  func displayData(viewModel: AlbumTracks.Model.ViewModel.ViewModelData)
}

class AlbumTracksViewController: UIViewController, AlbumTracksDisplayLogic {

  var interactor: AlbumTracksBusinessLogic?
  var router: (NSObjectProtocol & AlbumTracksRoutingLogic)?

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
    let interactor            = AlbumTracksInteractor()
    let presenter             = AlbumTracksPresenter()
    let router                = AlbumTracksRouter()
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
  
  func displayData(viewModel: AlbumTracks.Model.ViewModel.ViewModelData) {

  }
  
}
