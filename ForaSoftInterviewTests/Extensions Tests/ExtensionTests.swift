//
//  ExtensionTests.swift
//  ForaSoftInterviewTests
//
//  Created by Александр Галкин on 29.10.2021.
//

import XCTest
@testable import ForaSoftInterview

class ExtensionTests: XCTestCase {
    
    var font: UIFont?
    var imageView: UIImageView?
    var tableView: UITableView?
    let imageUrl = "https://docs.microsoft.com/ru-ru/windows/apps/design/controls/images/image-licorice.jpg"
    
    override func setUpWithError() throws {
        font = .avenir20
        imageView = UIImageView()
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), cell: TrackTableViewCell.self)
    }
    
    override func tearDownWithError() throws {
        font = nil
        imageView = nil
        tableView = nil
    }
    
    func testAvenirFontIsExists() {
        XCTAssertNotNil(font)
    }
    
    func testTableViewIsCreated() {
        XCTAssertNotNil(tableView)
    }
    
    func testImageDownloadingInBackgroud() {
        try? imageView?.fetchImageFromURL(url: imageUrl, completion: { data in
            XCTAssertNotNil(data)
        })
    }
}
