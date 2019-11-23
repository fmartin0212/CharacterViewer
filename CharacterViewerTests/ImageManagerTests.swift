//
//  ImageManagerTests.swift
//  CharacterViewerTests
//
//  Created by Frank Martin Jr on 11/23/19.
//  Copyright © 2019 FrankMartin. All rights reserved.
//

import XCTest
@testable import CharacterViewer

class ImageManagerTests: XCTestCase {

    var sut: ImageManager!
    
    override func setUp() {
        let networkManagerMock = NetworkManagerMock()
        sut = ImageManager(networkManager: networkManagerMock)
    }

    override func tearDown() {
        sut = nil
    }
    
    func test_fetchImage_ValidURLGiven_ShouldCompleteWithImage() {
        var fetchedImage: UIImage?
        
        let expectation = self.expectation(description: "Fetch Image Completion")
        sut.fetchImage(from: URL(string: "www.testimageurl.com")!) { (result) in
            switch result {
            case .success(let image):
                fetchedImage = image
                expectation.fulfill()
            case .failure(_):
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertNotNil(fetchedImage)
    }
    
    func test_fetchImage_InvalidURLGiven_ShouldCompleteWithError() {
        var imageManagerError: ImageManagerError?
        
        let expectation = self.expectation(description: "Fetch Image Completion")
        sut.fetchImage(from: URL(string: "1234hehe")!) { (result) in
            switch result {
            case .success(_):
                expectation.fulfill()
            case .failure(let error):
                imageManagerError = error
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertNotNil(imageManagerError)
    }
}
