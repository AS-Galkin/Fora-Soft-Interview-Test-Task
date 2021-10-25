//
//  NetworkLayer.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 25.10.2021.
//

import Foundation
import Alamofire

enum ApiEntity: String {
    case musicArtist
    case musicTrack
    case album
    case musicVideo
}

enum NetworkError: Error {
    case someError
}

class NetworkLayer {
    private var apiURL: String = "https://itunes.apple.com/search"
    private let limit: String = "150"
    public func fetchResult(searchText: String, entity: ApiEntity?, completion: @escaping (_ searchResult: String?) throws -> Void) {
        var parameters = ["term":"\(searchText)", "limit":limit]
        
        if let entity = entity {
            parameters["entity"] = entity.rawValue
        }
        
        let request = AF.request(apiURL, method: .get, parameters: parameters)
        request.response { data in
            
            if let error = data.error {
                print("SOme error")
            }
            
            guard let data = data.data else {
                return
            }
            
            do {
                //let model: SearchResponse = try JSONDecoder().decode(SearchResponse.self, from: data) as SearchResponse
                try completion(String(data: data, encoding: .utf8))
            } catch DecodingError.dataCorrupted {
            } catch {
            }
        }
    }
}
