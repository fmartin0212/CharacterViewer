//
//  TelevisionCharacterManagerTests.swift
//  CharacterViewerTests
//
//  Created by Frank Martin Jr on 11/23/19.
//  Copyright © 2019 FrankMartin. All rights reserved.
//

import XCTest
@testable import CharacterViewer

class TelevisionCharacterManagerTests: XCTestCase {
    
    var sut: TelevisionCharacterManager!
    
    override func setUp() {
        let networkworkManagerMock = NetworkManagerMock()
        sut = TelevisionCharacterManager(networkManager: networkworkManagerMock)
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func test_fetchCharacters_simpsonsURLGiven_ShouldReturnDecodedSimpsonsCharacter() {
        var fetchedCharacters = [TelevisionCharacter]()

        let expectation = self.expectation(description: "Fetch Characters Completion")
        sut.fetchCharacters(for: .simpsons) { (result) in
            switch result {
            case .success(let characters):
                fetchedCharacters = characters
                expectation.fulfill()

            case .failure(_):
                expectation.fulfill()
                break

            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertTrue(fetchedCharacters.first!.text.contains("Simpsons"))
    }
    
    func test_fetchCharacters_theWireURLGiven_ShouldReturnDecodedWireCharacter() {
        var fetchedCharacters = [TelevisionCharacter]()
        
        let expectation = self.expectation(description: "Fetch Characters Completion")
        sut.fetchCharacters(for: .theWire) { (result) in
            switch result {
            case .success(let characters):
                fetchedCharacters = characters
                expectation.fulfill()
                
            case .failure(_):
                expectation.fulfill()
                break
                
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertTrue(fetchedCharacters.first!.text.contains("Wire"))
    }
}
