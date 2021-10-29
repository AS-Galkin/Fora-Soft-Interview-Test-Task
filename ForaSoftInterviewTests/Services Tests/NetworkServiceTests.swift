//
//  NetworkServiceTests.swift
//  ForaSoftInterviewTests
//
//  Created by Александр Галкин on 29.10.2021.
//

import XCTest
import Alamofire
@testable import ForaSoftInterview

class NetworkServiceTests: XCTestCase {

    var network: NetworkLayer?
    
    override func setUpWithError() throws {
        network = NetworkLayer()
    }

    override func tearDownWithError() throws {
        network = nil
    }
    
    func testFetchingAlbumsWithNetworkService() {
        network?.fetchResult(url: .searchApiURL, limit: 20, searchText: "30 Seconds", completion: { (searchResult: SearchResponse<Album>?, error: AFError?) -> Void in
            XCTAssertNotNil(searchResult)
        })
    }

}
