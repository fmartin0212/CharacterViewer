//
//  CharacterListViewControllerTests.swift
//  CharacterViewerTests
//
//  Created by Frank Martin Jr on 11/23/19.
//  Copyright © 2019 FrankMartin. All rights reserved.
//

import XCTest
@testable import CharacterViewer

class CharacterListViewControllerTests: XCTestCase {

    var sut: CharacterListViewController!
    var navController: UINavigationController!
    var coordinatorMock: CharacterListVCCoordinatorDelegateMock! {
        return sut.coordinatorDelegate as? CharacterListVCCoordinatorDelegateMock
    }
    
    override func setUp() {
        sut = UIStoryboard.characterViewerMain.instantiateViewController(withIdentifier: "CharacterListViewController") as? CharacterListViewController
        let networkManagerMock = NetworkManagerMock()
        let tvCharacterManagerMock = TelevisionCharacterManager(networkManager: networkManagerMock)
        let characterListViewModel = CharacterListViewModel(characterManager: tvCharacterManagerMock, app: .simpsons)
        let coordinatorDelegateMock = CharacterListVCCoordinatorDelegateMock()
        sut.characterListViewModel = characterListViewModel
        sut.coordinatorDelegate = coordinatorDelegateMock
        navController = NavigationControllerMock(rootViewController: sut)
        _ = sut.view
    }

    override func tearDown() {
        sut = nil
        navController = nil
    }
    
    func test_sut_ShouldBeTableViewDataSource() {
        XCTAssertTrue(sut.tableView.dataSource is CharacterListViewController )
    }
    
    func test_sut_ShouldBeTableViewDelegate() {
        XCTAssertTrue(sut.tableView.delegate is CharacterListViewController )
    }
    
    func test_sut_ShouldBeSearchBarDelegate() {
        XCTAssertTrue(sut.searchBar.delegate is CharacterListViewController )
    }
    
    func test_numberOfRowsInSection_ShouldBeOne() {
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 1)
    }
    
    func test_DidSelectRow_ShouldDelegateToCoordinator() {
        sut.tableView(sut.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        XCTAssertTrue(coordinatorMock.userDidSelectRowWasCalled)
    }
    
    func test_searchBarTextDidChange_ShouldDelegateToCoordinator() {
        sut.searchBar(sut.searchBar, textDidChange: "FooBar")
        
        XCTAssertTrue(coordinatorMock.searchBarTextDidChangeWasCalled)
    }
}

class CharacterListVCCoordinatorDelegateMock: CharacterListViewControllerCoordinatorDelegate {
    var userDidSelectRowWasCalled = false
    var searchBarTextDidChangeWasCalled = false
    
    func userDidSelectRow(at indexPath: IndexPath, on viewController: CharacterListViewController) {
        userDidSelectRowWasCalled = true
    }
    
    func searchBar(textDidChange searchText: String, on viewController: CharacterListViewController, listViewModel: CharacterListViewModel) {
        searchBarTextDidChangeWasCalled = true
    }
}
