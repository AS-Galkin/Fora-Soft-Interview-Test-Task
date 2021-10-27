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
      case .presentTracks(var response):
          guard !response.results!.isEmpty else { return }
          response.results?.removeFirst()
          
          guard let cells = response.results?.map({ track in
              return TrackViewModel.Track.init(trackName: track.trackName)
          }) else { return }
          
          let viewModel = TrackViewModel.init(artistName: response.results?.first?.artistName, albumName: response.results?.first?.collectionName, artWork: response.results?.first?.artworkUrl100, cells: cells)
          viewController?.displayData(viewModel: .displayTracks(trackViewModel: viewModel))
          break
      @unknown default:
          break
      }
  }
  
}
