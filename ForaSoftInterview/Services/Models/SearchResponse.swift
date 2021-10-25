//
//  SearchResponse.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 25.10.2021.
//

import Foundation

protocol ItunesModelProtocol: Decodable {
    var artistId: Int? { get set }
    
    var collectionId: Int? { get set }
    
    var artworkUrl100: String? { get set }
    
    var artworkUrl60: String? { get set }
    
    var artistName: String? { get set }
}

struct SearchResponse<T: Decodable>: Decodable {
    var resultCount: Int?
    
    var results: [T]?
}

struct Album: ItunesModelProtocol {
    var artistId: Int?
    
    var collectionId: Int?
    
    var artworkUrl100: String?
    
    var artworkUrl60: String?
    
    var artistName: String?
    
    var collectionName: String?
    
    var trackCount: Int?
}

struct Track: ItunesModelProtocol {
    var artistId: Int?
    
    var collectionId: Int?
    
    var artworkUrl100: String?
    
    var artworkUrl60: String?
    
    var trackId: Int?
    
    var trackName: String?
    
    var artistName: String?
}
