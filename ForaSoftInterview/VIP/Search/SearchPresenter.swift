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
    weak var viewController: SearchDisplayLogic?
    
    //MARK: - Preparation data for displaying
    func presentData(response: Search.Model.Response.ResponseType) {
        switch response {
        case .presentAlbums(let response):
            
            //Convert ResponseViewModel to AlbumViewModel. And Aphabet sorting.
            guard let cells = response?.results?.map({ album -> AlbumViewModel.Album in
                return AlbumViewModel.Album.init(imageUrl: album.artworkUrl100, artistName: album.artistName, albumName: album.collectionName, albumId: album.collectionId)
            }).sorted(by: { lhs, rhs in
                guard let left = lhs.albumName, let right = rhs.albumName else { return false}
                return left < right
            }) else { return }

            let viewModel = AlbumViewModel.init(cells: cells)
            
            viewController?.displayData(viewModel: .displayAlbums(albumViewModel: viewModel))
            break
        case .presentActivityIndicator:
            viewController?.displayData(viewModel: .displayActivityIndicator)
        case .removeActivityIndicator:
            viewController?.displayData(viewModel: .hideActivityIndicator)
        @unknown default:
            break
            
        }
    }
    
}
