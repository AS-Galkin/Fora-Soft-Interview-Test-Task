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

class SearchViewController: UIViewController, SearchDisplayLogic {
    
    //MARK: - Variabels
    var interactor: SearchBusinessLogic?
    
    var router: (NSObjectProtocol & SearchRoutingLogic)?
    
    var timer: Timer?
    
    var albumCollectionView: UICollectionView!
    
    let activityView: ActivityView = ActivityView(frame: UIScreen.main.bounds)
    
    private var albumCellViewModel: AlbumViewModel = AlbumViewModel(cells: []) {
        didSet {
            albumCollectionView.reloadData()
        }
    }
    
    let sectionInsets = UIEdgeInsets(top: 16.0, left: 17.0, bottom: 20.0, right: 17.0)
    
    let itemsPerRow = 2.0
    
    let minimalSpacing = 15.0
    
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
        let interactor            = SearchInteractor()
        let presenter             = SearchPresenter()
        let router                = SearchRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    // MARK: View lifecycle
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        albumCollectionView = generateCollectionView()
        self.view.addSubview(albumCollectionView)
        self.view.addSubview(activityView)
        setupNavItemSearchVC()
    }
    
    //MARK: - Displaying data
    func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayAlbums(let result):
            albumCellViewModel = result
            break
        case .displayActivityIndicator:
            activityView.showActivity()
            activityView.isHidden = false
            break
        case .hideActivityIndicator:
            activityView.hideActivity()
            activityView.isHidden = true
            break
        @unknown default:
            break
        }
    }
    
    private func setupNavItemSearchVC() {
        let search = UISearchController()
        search.searchBar.delegate = self
        search.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumCellViewModel.cells.count
    }
    
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let id = albumCellViewModel.cells[indexPath.row].albumId {
            router?.routeToDetailViewController(idCollection: id)
        }
    }
}

//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] _ in
            self?.interactor?.makeRequest(request: .getAlbums(searchTerm: searchText))
        })
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = sectionInsets.left + sectionInsets.right + CGFloat(minimalSpacing * (itemsPerRow - 1))
        let availableWidth = collectionView.bounds.width - padding
        let widthPerItem = Double(availableWidth) / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem + 50)
    }
        
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
