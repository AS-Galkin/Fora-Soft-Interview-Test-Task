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
    
    var interactor: SearchBusinessLogic?
    var router: (NSObjectProtocol & SearchRoutingLogic)?
    var timer: Timer?
    var albumCollectionView: UICollectionView!
    private var albumCellViewModel: AlbumViewModel = AlbumViewModel(cells: []) {
        didSet {
            albumCollectionView.reloadData()
        }
    }
    let sectionInsets = UIEdgeInsets(top: 16.0, left: 17, bottom: 20.0, right: 17.0)
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
        setupNavItemSearchVC()
    }
    
    func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayAlbums(let result):
            albumCellViewModel = result
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

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumCellViewModel.cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.reuseId, for: indexPath) as! AlbumCollectionViewCell
        cell.artistNameLabel.text = albumCellViewModel.cells[indexPath.row].artistName
        cell.albumNameLabel.text = albumCellViewModel.cells[indexPath.row].albumName
        if let url = URL(string:albumCellViewModel.cells[indexPath.row].imageUrl ?? ""),
           let imageData = try? Data(contentsOf: url) {
            cell.albumImageView.image = UIImage(data: imageData)
        }
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] _ in
            self?.interactor?.makeRequest(request: .getAlbums(searchTerm: searchText))
        })
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = sectionInsets.left + sectionInsets.right + CGFloat(minimalSpacing * (itemsPerRow - 1))
        let availableWidth = collectionView.bounds.width - padding
        let widthPerItem = Int(availableWidth) / itemsPerRow
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
