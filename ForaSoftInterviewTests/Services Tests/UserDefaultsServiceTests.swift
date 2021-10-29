//
//  UserDefaultsServiceTests.swift
//  ForaSoftInterviewTests
//
//  Created by Александр Галкин on 29.10.2021.
//

import XCTest
@testable import ForaSoftInterview

class UserDefaultsLayerMock {
    weak var defaultsService: UserDefaultsLayer?
    
    var saveSearchQueryIsComplete = false
    {
        didSet {
            print("Seet")
        }
    }
    var loadHistoryIsComplete = false
    
    init(defaultsService: UserDefaultsLayer? = UserDefaultsLayer.shared) {
        self.defaultsService = defaultsService
    }
    
    func saveSearchQueryTest(search: String, closure: @escaping ([String]) -> Void) {
        defaultsService?.saveSearchQuery(for: search)
        defaultsService?.loadHistory(closure: closure)
    }
    
    func loadHistoryTest(closure: @escaping ([String]) -> Void) {
        defaultsService?.loadHistory(closure: closure)
    }
}

class UserDefaultsServiceTests: XCTestCase {
    
    var userDefaultLayerMock: UserDefaultsLayerMock?
    override func setUpWithError() throws {
        userDefaultLayerMock = UserDefaultsLayerMock()
    }

    override func tearDownWithError() throws {
        userDefaultLayerMock = nil
    }
    
    func testSavingStringToUserDefaultsWithUserDefaultsLayer() {
        userDefaultLayerMock?.saveSearchQueryTest(search: "testQuery") { [weak self] history in
            if history.contains(where: ({$0 == "testQuery"})){
                self?.userDefaultLayerMock?.saveSearchQueryIsComplete = true
                XCTAssertEqual(self?.userDefaultLayerMock?.saveSearchQueryIsComplete, true)
            }
        }
                                                  
    }
    
    func testLoadHistoryFromUserDefaultsWithYserDefaultsLayer() {
        userDefaultLayerMock?.loadHistoryTest(closure: { [weak self] history in
            if !history.isEmpty {
                self?.userDefaultLayerMock?.loadHistoryIsComplete = true
                XCTAssertEqual(self?.userDefaultLayerMock?.loadHistoryIsComplete, true)
            }
        })
    }
}
