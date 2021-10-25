//
//  SearchModels.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 25.10.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum Search {
   
  enum Model {
    struct Request {
      enum RequestType {
          case getAlbums(searchTerm: String)
          case getTracks(searchTerm: String)
      }
    }
    struct Response {
      enum ResponseType {
          case presentAlbums(responseTerm: SearchResponse<Album>?)
          case presentTracks(responseTerm: SearchResponse<Track>?)
      }
    }
    struct ViewModel {
      enum ViewModelData {
          case displayAlbums(albumViewModel: AlbumViewModel)
          case dislayTracks(trackViewModel: TrackViewModel)
      }
    }
  }
  
}

struct AlbumViewModel {
    
}

struct TrackViewModel {
    
}
