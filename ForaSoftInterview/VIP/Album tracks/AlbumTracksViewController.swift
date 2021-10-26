//
//  AlbumTracksViewController.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 26.10.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol AlbumTracksDisplayLogic: AnyObject {
    func displayData(viewModel: AlbumTracks.Model.ViewModel.ViewModelData)
}

class AlbumTracksViewController: UIViewController, AlbumTracksDisplayLogic {
    
    var interactor: AlbumTracksBusinessLogic?
    var router: (NSObjectProtocol & AlbumTracksRoutingLogic)?
    var collectionId: Int?
    var trackTableView: UITableView!
    var trackCellViewModel: TrackViewModel = TrackViewModel(cells: []) {
        didSet {
            trackTableView.reloadData()
        }
    }
    
    // MARK: Object lifecycle

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    init(collectionId: Int) {
        self.collectionId = collectionId
        super.init(nibName: nil, bundle: nil)
        print(#function)
        setup()
        view.backgroundColor = .white
        
    }
    
    // MARK: Setup
    
    private func setup() {
        print(#function)
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
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackTableView = generateTableView()
        self.view.addSubview(trackTableView)
        if let id = collectionId {
            interactor?.makeRequest(request: .getTracks(lookupTerm: String(id)))
        }
    }
    
    private func generateTableView() -> UITableView {
        let tabelview = UITableView(frame: self.view.frame, style: .plain)
        tabelview.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tabelview.backgroundColor = .white
        tabelview.delegate = self
        tabelview.dataSource = self
        return tabelview
    }
    
    func displayData(viewModel: AlbumTracks.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayTracks(let tracks):
            trackCellViewModel = tracks
            break
        @unknown default:
            break
        }
    }
    
}

extension AlbumTracksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackCellViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        cell.textLabel?.text = trackCellViewModel.cells[indexPath.row].trackName
        return cell
    }
    
    
}
