//
//  NetworkLayer.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 25.10.2021.
//

import Foundation
import Alamofire

enum iTunesApiEntity: String {
    case musicArtist
    case musicTrack
    case album
    case musicVideo
}

enum iTunesApiURLs: String {
    case searchApiURL = "https://itunes.apple.com/search"
    case lookupApiURL = "https://itunes.apple.com/lookup"
}

enum NetworkError: Error {
    case someError
}

class NetworkLayer {
    func fetchResult<T: Decodable>(url: iTunesApiURLs, limit: Int, searchText: String, entity: iTunesApiEntity = .album, completion: @escaping (_ searchResult: SearchResponse<T>?, _ error: AFError?) -> Void) {
        
        var parameters:[String:String] =  ["Country":"RU", "entity":entity.rawValue, "limit":String(limit)]
        
        switch url {
        case .searchApiURL:
            parameters["term"] = "\(searchText)"
        case .lookupApiURL:
            parameters["id"] = "\(searchText)"
        @unknown default:
            break
        }
        
        let request = AF.request(url.rawValue, method: .get, parameters: parameters)
        request.response { data in
            guard let rawData = data.data else {
                return
            }
            
            do {
                let model: SearchResponse = try JSONDecoder().decode(SearchResponse.self, from: rawData) as SearchResponse<T>
                completion(model, nil)
            } catch DecodingError.dataCorrupted {
                completion(nil, data.error)
            } catch {
                completion(nil, data.error)
            }
        }
    }
}
