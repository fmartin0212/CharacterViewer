//
//  NetworkManagerTests.swift
//  CharacterViewerTests
//
//  Created by Frank Martin Jr on 11/23/19.
//  Copyright © 2019 FrankMartin. All rights reserved.
//

import XCTest
@testable import CharacterViewer

class NetworkManagerTests: XCTestCase {
    
    var sut: NetworkManager!

    override func setUp() {
        sut = NetworkManager(session: URLSessionMock())
    }

    override func tearDown() {
        sut = nil
    }
    
    func test_fetch_ValidURLGiven_ShouldCompleteWithData() {
        let expectation = self.expectation(description: "Fetch Completion Handler")
        
        sut.fetch(from: URL(string: "www.SomeValidURL.com")!) { (result) in
            expectation.fulfill()
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func foo() {
    }
}
