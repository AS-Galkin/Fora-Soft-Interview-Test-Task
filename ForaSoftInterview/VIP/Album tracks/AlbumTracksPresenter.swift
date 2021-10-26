//
//  AlbumTracksPresenter.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 26.10.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol AlbumTracksPresentationLogic {
  func presentData(response: AlbumTracks.Model.Response.ResponseType)
}

class AlbumTracksPresenter: AlbumTracksPresentationLogic {
  weak var viewController: AlbumTracksDisplayLogic?
  
  func presentData(response: AlbumTracks.Model.Response.ResponseType) {
      switch response {
      case .presentTracks(let response):
          guard let cells = response.results?.map({ track -> TrackViewModel.Track in
              return TrackViewModel.Track.init(trackName: track.trackName, artistName: track.artistName, albumName: track.collectionName)
          }) else { return }
          viewController?.displayData(viewModel: .displayTracks(trackViewModel: TrackViewModel.init(cells: cells)))
          break
      @unknown default:
          break
      }
  }
  
}
