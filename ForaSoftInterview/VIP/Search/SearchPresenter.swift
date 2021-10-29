//
//  SearchPresenter.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 25.10.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchPresentationLogic {
    func presentData(response: Search.Model.Response.ResponseType)
}

class SearchPresenter: SearchPresentationLogic {
    /// Weak link to ViewController
    weak var viewController: SearchDisplayLogic?
    
    //MARK: - Preparation data for displaying
    /**
     Prepare data reached from interactor and send it to ViewController. Present making depending on *ResponseType*.
     */
    func presentData(response: Search.Model.Response.ResponseType) {
        switch response {
            /// Prepare and send data to viewController
        case .prepareResponse(let response):
            ///Convert ResponseViewModel to AlbumViewModel. And Aphabet sorting.
            guard let cells = response?.results?.map({ album -> AlbumViewModel.Album in
                /// Maping SearchViewModel to AlbumViewModel
                return AlbumViewModel.Album.init(imageUrl: album.artworkUrl100, artistName: album.artistName, albumName: album.collectionName, albumId: album.collectionId)
            }).sorted(by: { lhs, rhs in
                /// Alphaet sorting
                guard let left = lhs.albumName, let right = rhs.albumName else { return false}
                return left < right
            }) else { return }

            let viewModel = AlbumViewModel.init(cells: cells)
            /// Sending prepared date to ViewController
            viewController?.displayData(viewModel: .displayAlbums(albumViewModel: viewModel))
            break
            /// Says ViewController that need to display Loading Indicator
        case .presentActivityIndicator:
            viewController?.displayData(viewModel: .displayActivityIndicator)
            /// Says ViewController that need to stop display Loading Indicator
        case .removeActivityIndicator:
            viewController?.displayData(viewModel: .hideActivityIndicator)
        @unknown default:
            break
            
        }
    }
    
}
