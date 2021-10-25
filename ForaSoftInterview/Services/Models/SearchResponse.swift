//
//  SearchResponse.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 25.10.2021.
//

import Foundation

struct SearchResponse<T: Decodable>: Decodable {
    var resultCount: Int?
    var results: [T]?
}

struct Album: Decodable {
    var artistId: Int?
    var collectionId: Int?
    var artistName: String?
    var collectionName: String?
    var artistViewUrl: String?
    var artworkUrl100: String?
    var artworkUrl60: String?
    var trackCount: Int?
}

struct Track: Decodable {
    
}
