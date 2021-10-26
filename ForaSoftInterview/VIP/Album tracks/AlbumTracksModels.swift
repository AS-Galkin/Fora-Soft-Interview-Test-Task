//
//  AlbumTracksModels.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 26.10.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum AlbumTracks {
   
  enum Model {
    struct Request {
      enum RequestType {
          case getTracks(lookupTerm: String)
      }
    }
    struct Response {
      enum ResponseType {
          case presentTracks(response: SearchResponse<Track>)
      }
    }
    struct ViewModel {
      enum ViewModelData {
          case displayTracks(trackViewModel: TrackViewModel)
      }
    }
  }
  
}

struct TrackViewModel {
    struct Track {
        var trackName: String?
        var artistName: String?
        var albumName: String?
    }
    
    var cells: [Track]
}
