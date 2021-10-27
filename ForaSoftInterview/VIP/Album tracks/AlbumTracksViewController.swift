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
    
    // MARK: - Variables
    var interactor: AlbumTracksBusinessLogic?
    
    var router: (NSObjectProtocol & AlbumTracksRoutingLogic)?
    
    var collectionId: Int?
    
    var trackTableView: UITableView!
    
    var trackTableHeaderView: TrackTableHeaderView!
    
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
        navigationItem.largeTitleDisplayMode = .never
        trackTableView = generateTableView()
        self.view.addSubview(trackTableView)
        if let id = collectionId {
            interactor?.makeRequest(request: .getTracks(lookupTerm: String(id)))
        }
    }
    
    private func generateTableView() -> UITableView {
        let tableView = UITableView(frame: self.view.frame)
        let nibName = UINib(nibName: "TrackTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: TrackTableViewCell.reuseId)
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing:TrackTableViewCell.self), for: indexPath) as? TrackTableViewCell else { return UITableViewCell()}
        
        let cellData = trackCellViewModel.cells[indexPath.row]
        cell.trackNameLabel.text = cellData.trackName
        cell.artistNameLabel.text = trackCellViewModel.artistName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIScreen.main.bounds.width - 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if !trackCellViewModel.cells.isEmpty {
            trackTableHeaderView = TrackTableHeaderView(imageUrl: trackCellViewModel.artWork, albumName: trackCellViewModel.albumName, artistName: trackCellViewModel.artistName)
            return trackTableHeaderView
        } else {
            return TrackTableHeaderView()
        }
    }
}
