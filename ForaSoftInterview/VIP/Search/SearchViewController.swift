//
//  SearchViewController.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 25.10.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchDisplayLogic: AnyObject {
    func displayData(viewModel: Search.Model.ViewModel.ViewModelData)
}

/*
 # Controller that displays Searched albums
 */

class SearchViewController: UIViewController, SearchDisplayLogic {
    
    //MARK: - Variabels
    /// Interactor that interact with external services.
    var interactor: SearchBusinessLogic?
    /// Routing between Screens, controllers, etc.
    var router: (NSObjectProtocol & SearchRoutingLogic)?
    /// Timer for delay of search
    var timer: Timer?
    /// controller for searching
    var searchController: UISearchController?
    /// view for demostrate searched albums
    var albumCollectionView: UICollectionView!
    /// view that indicate loading process
    let activityView: ActivityView = ActivityView(frame: UIScreen.main.bounds)
    /// internal object to store Albums
    private var albumCellViewModel: AlbumViewModel = AlbumViewModel(cells: []) {
        /// Reloading CollectionView when set new data
        didSet {
            albumCollectionView.reloadData()
        }
    }
    /// Edges for CollectionLayout
    let sectionInsets = UIEdgeInsets(top: 16.0, left: 17.0, bottom: 20.0, right: 17.0)
    /// How many items will in row
    let itemsPerRow = 2.0
    /// spacing between cells
    let minimalSpacing = 15.0
    
    // MARK: - Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Setup
    /// Setup VIP circle
    private func setup() {
        let viewController        = self
        let interactor            = SearchInteractor()
        let presenter             = SearchPresenter()
        let router                = SearchRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    // MARK: - View lifecycle
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        albumCollectionView = generateCollectionView()
        self.view.addSubview(albumCollectionView)
        self.view.addSubview(activityView)
        setupSearchViewController()
    }
    
    //MARK: - Displaying data
    /**
     Displaying viewing content depending on the *ViewModelData*.
     */
    func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
        switch viewModel {
            /// Displaying albums when they loaded
        case .displayAlbums(let result):
            albumCellViewModel = result
            break
            /// Displaying Loading Indicator while Albums loading
        case .displayActivityIndicator:
            activityView.showActivity()
            activityView.isHidden = false
            break
            /// Hide Loading Indicator when Albums loaded
        case .hideActivityIndicator:
            activityView.hideActivity()
            activityView.isHidden = true
            break
        @unknown default:
            break
        }
    }
    
    //MARK: - Other methods
    /**
     Setup searchViewController as part of NavigationBar.
     */
    private func setupSearchViewController() {
        searchController = UISearchController()
        /// Set self as delegate of searchBar
        searchController?.searchBar.delegate = self
        searchController?.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    /**
     Generate CollectionView with layout and xib of AlbumCollectionViewCell.
     */
    private func generateCollectionView() -> UICollectionView {
        let collection = UICollectionView(frame: self.view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(AlbumCollectionViewCell.nib, forCellWithReuseIdentifier: AlbumCollectionViewCell.reuseId)
        collection.backgroundColor = .white
        collection.delegate = self
        collection.dataSource = self
        return collection
    }
    
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    /// How manu cell show
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumCellViewModel.cells.count
    }
    /// Fill up fields of cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.reuseId, for: indexPath) as! AlbumCollectionViewCell
        
        let cellData = albumCellViewModel.cells[indexPath.row]
        
        cell.artistNameLabel.text = cellData.artistName
        cell.albumNameLabel.text = cellData.albumName
        
        do {
            try cell.albumImageView.fetchImageFromURL(url: cellData.imageUrl)
        } catch let error as NSError {
            print("Error \(error.userInfo["DetailMessage"])")
        }
        
        return cell
    }
    
    //MARK: - Routing
    /// Subway by selectin cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /// Route to ViewController with tracks of selected album.
        if let id = albumCellViewModel.cells[indexPath.row].albumId {
            router?.routeToTracksViewController(idCollection: id)
        }
    }
}

//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    /// Get input text from searchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        ///reset timer
        timer?.invalidate()
        
        /// send data from search to interactor afte 1 second delay.
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] _ in
            if !searchText.isEmpty {
                self?.interactor?.makeRequest(request: .saveTerm(searchTerm: searchText))
                self?.interactor?.makeRequest(request: .getAlbums(searchTerm: searchText))
            }
        })
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    /// Size for each item in CollectionViewLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        /// Calculate summary padding of all edges
        let padding = sectionInsets.left + sectionInsets.right + CGFloat(minimalSpacing * (itemsPerRow - 1))
        /// calculate free screen space with taking *padding*
        let availableWidth = collectionView.bounds.width - padding
        /// calculate size of each cell item
        let widthPerItem = Double(availableWidth) / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem + 50)
    }
    /// Minimal spacing between
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(minimalSpacing)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}


//MARK: - UIKit+SwiftUI+Canvas
import SwiftUI

/// Struct for usng Canvas ig project.
struct ViewControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let vc = SearchViewController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
