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

/*
 # Class that displaying Tracks of album.
 */
class AlbumTracksViewController: UIViewController, AlbumTracksDisplayLogic {
    
    // MARK: - Variables
    /// Interactor that interact with external services.
    var interactor: AlbumTracksBusinessLogic?
    /// Routing between Screens, controllers, etc.
    var router: (NSObjectProtocol & AlbumTracksRoutingLogic)?
    /// Id collection for which needs to download tracks
    var collectionId: Int?
    /// TableView of tacks
    var trackTableView: UITableView?
    /// Header of TableView
    var trackTableHeaderView: TrackTableHeaderView?
    /// Internal viewModel with data for filling up cells
    var trackCellViewModel: TrackViewModel = TrackViewModel(cells: []) {
        /// Reloading tableView when set new data
        didSet {
            guard let table = trackTableView else { return }
            table.reloadData()
        }
    }
    
    // MARK: - Object lifecycle
    
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
    
    // MARK: - Setup
    /// Setup VIP circle
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
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        trackTableView = generateTableView()
        
        guard let table = trackTableView else { return }
        
        self.view.addSubview(table)
        /// Starts downloading tracks.
        if let id = collectionId {
            interactor?.makeRequest(request: .getTracks(lookupTerm: String(id)))
        }
    }
    
    //MARK: - Displying Data
    /**
     Displaying viewing content depending on the *ViewModelData*.
     */
    func displayData(viewModel: AlbumTracks.Model.ViewModel.ViewModelData) {
        switch viewModel {
            /// Displaying Tracks when they loaded
        case .displayTracks(let tracks):
            trackCellViewModel = tracks
            break
        @unknown default:
            break
        }
    }
    
    //MARK: - Other methods
    /**
     Generate TableView with xib of TrackTableViewCell.
     */
    private func generateTableView() -> UITableView {
        let tableView = UITableView(withNib: TrackTableViewCell.self,frame: self.view.frame)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension AlbumTracksViewController: UITableViewDelegate, UITableViewDataSource {
    /// How many Cells to show
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackCellViewModel.cells.count
    }
    /// Fill up fields in cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing:TrackTableViewCell.self), for: indexPath) as? TrackTableViewCell else { return UITableViewCell()}
        
        let cellData = trackCellViewModel.cells[indexPath.row]
        cell.trackNameLabel.text = cellData.trackName
        cell.artistNameLabel.text = trackCellViewModel.artistName
        return cell
    }
    /// Size of Table Section Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIScreen.main.bounds.width - 50
    }
    /// Fill up fields of header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if !trackCellViewModel.cells.isEmpty {
            trackTableHeaderView = TrackTableHeaderView(imageUrl: trackCellViewModel.artWork, albumName: trackCellViewModel.albumName, artistName: trackCellViewModel.artistName)
            return trackTableHeaderView
        } else {
            return TrackTableHeaderView()
        }
    }
}
