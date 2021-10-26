//
//  DetailModels.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 26.10.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum Detail {
   
  enum Model {
    struct Request {
      enum RequestType {
          case getTacks(lookupTerm: String)
      }
    }
    struct Response {
      enum ResponseType {
          case presentTracks(responseTerm: SearchResponse<Track>?)
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
        
    }
    
    var cells: [Track]
}
