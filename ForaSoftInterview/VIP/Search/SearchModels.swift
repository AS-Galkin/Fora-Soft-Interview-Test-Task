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
          case saveTerm(searchTerm: String)
      }
    }
    struct Response {
      enum ResponseType {
          case prepareResponse(responseTerm: SearchResponse<Album>?)
          case presentActivityIndicator
          case removeActivityIndicator
      }
    }
    struct ViewModel {
      enum ViewModelData {
          case displayAlbums(albumViewModel: AlbumViewModel)
          case displayActivityIndicator
          case hideActivityIndicator
      }
    }
  }
  
}

struct AlbumViewModel {
    struct Album {
        var imageUrl: String?
        var artistName: String?
        var albumName: String?
        var albumId: Int?
    }
    
    var cells: [Album]
}

