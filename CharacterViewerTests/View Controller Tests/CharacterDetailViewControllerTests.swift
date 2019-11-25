//
//  CharacterDetailViewController.swift
//  CharacterViewerTests
//
//  Created by Frank Martin Jr on 11/23/19.
//  Copyright © 2019 FrankMartin. All rights reserved.
//

import XCTest
@testable import CharacterViewer

class CharacterDetailViewControllerTests: XCTestCase {
    
    var sut: CharacterDetailViewController!

    override func setUp() {
        sut = UIStoryboard.characterViewerMain.instantiateViewController(withIdentifier: "CharacterDetailViewController") as? CharacterDetailViewController
        
        let televisionCharacter = TelevisionCharacter(text: "My character (The Wire) - My character is a fictional...", icon: nil)
        let characterDetailViewModel = CharacterDetailViewModel(model: televisionCharacter)
        sut.characterDetailViewModel = characterDetailViewModel
        
        let coordinatorMock = CharacterDetailViewControllerDelegateMock()
        sut.coordinatorDelegate = coordinatorMock
        
        _ = sut.view
    }

    override func tearDown() {
        sut = nil
    }
    
    func test_viewDidLoad_ShouldDelegateToCoordinator() {
        guard let coordinatorMock = sut.coordinatorDelegate as? CharacterDetailViewControllerDelegateMock else { XCTFail("Failed to cast coordinator as mock") ; return }
        
        XCTAssertTrue(coordinatorMock.viewDidLoadCalled)
    }
}

class CharacterDetailViewControllerDelegateMock: CharacterDetailViewControllerDelegate {
    var viewDidLoadCalled = false
    
    func characterDetailViewDidLoad(viewController: CharacterDetailViewController, viewModel: CharacterDetailViewModel) {
        viewDidLoadCalled  = true
    }
}
