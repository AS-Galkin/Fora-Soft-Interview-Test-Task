//
//  NetworkLayer.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 25.10.2021.
//

import Foundation
import Alamofire

/// Struct that contains some Entity wich provides iTunes API.
enum iTunesApiEntity: String {
    case musicArtist
    case musicTrack
    case album
    case musicVideo
    case song
}

/// Struct that contains some String for working with Itunes API.
enum iTunesApiURLs: String {
    case searchApiURL = "https://itunes.apple.com/search"
    case lookupApiURL = "https://itunes.apple.com/lookup"
}

class NetworkLayer {
    
    private let countryAPI = "RU"
    private let parametersKeys = ["Country","entity", "limit", "term", "id"]
    
    /**
     Loading data from Itunes API and decodinf it into *SearchResponse* model.
     - returns:
     Void
     - parameters:
        - T: Generic type. That using to describe what entity of decoding we will use. Must conforms *Decodable*.
        - url: some iTunesAPI url
        - limit: Linit of out stream from iTunes Api.
        - searchText: Artist or Album that will search.
        - entity: Entity that iTunes api will provide.
        - completion: Describe what will doing with decoding data grom Api.
     */
    func fetchResult<T: Decodable>(url: iTunesApiURLs, limit: Int, searchText: String, entity: iTunesApiEntity = .album, completion: @escaping (_ searchResult: SearchResponse<T>?, _ error: AFError?) -> Void) {
        
        /// Dictionary of parameters that will send to searching request
        var parameters:[String:String] =  [parametersKeys[0]: countryAPI, parametersKeys[1]: entity.rawValue, parametersKeys[2]: String(limit)]
        switch url {
        case .searchApiURL:
            parameters[parametersKeys[3]] = "\(searchText)"
        case .lookupApiURL:
            parameters[parametersKeys[4]] = "\(searchText)"
        @unknown default:
            break
        }
        
        /// Creating request using Alamofire and download data asynchronosly
        let request = AF.request(url.rawValue, method: .get, parameters: parameters)
        
        /// Getting response of request and decode fetched data.
        request.response { data in
            guard let rawData = data.data else {
                return
            }
            do {
                /// Decoding fetched data into *SearchResponce<T>* model.
                let model: SearchResponse = try JSONDecoder().decode(SearchResponse.self, from: rawData) as SearchResponse<T>
                /// Call completion with decoded data
                completion(model, nil)
            } catch DecodingError.dataCorrupted {
                /// Call completion with error
                completion(nil, data.error)
            } catch {
                /// Call completion with error
                completion(nil, data.error)
            }
        }
    }
}
