//
//  CharacterDetailViewModelTests.swift
//  CharacterViewerTests
//
//  Created by Frank Martin Jr on 11/23/19.
//  Copyright © 2019 FrankMartin. All rights reserved.
//

import XCTest
@testable import CharacterViewer

class CharacterDetailViewModelTests: XCTestCase {

    var sut: CharacterDetailViewModel!
    
    override func setUp() {
        let televisionCharacter = TelevisionCharacter(text: "My character (The Wire) - My character is a fictional...", icon: Icon(urlString: "www.imageURLString.com"))
        sut = CharacterDetailViewModel(model: televisionCharacter)
    }

    override func tearDown() {
        sut = nil
    }

    func test_title_ShouldBeTextBeforeTheDash_And_ShouldOmitTheShowNameInParenthesis() {
        XCTAssertEqual(sut.title, "My character")
    }
    
    func test_description_ShouldBeTheTextWithoutTheCharacterName() {
        XCTAssertEqual(sut.description, "My character is a fictional...")
    }
    
    func test_imageURL_NonNilIconPropertyGiven_ShouldNonNil() {
        XCTAssertNotNil(sut.imageURL)
    }
}
