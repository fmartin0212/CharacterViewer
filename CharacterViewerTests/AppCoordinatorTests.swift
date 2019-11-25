//
//  AppCoordinatorTests.swift
//  CharacterViewerTests
//
//  Created by Frank Martin Jr on 11/23/19.
//  Copyright © 2019 FrankMartin. All rights reserved.
//

import XCTest
@testable import CharacterViewer

class AppCoordinatorTests: XCTestCase {

    var sut: AppCoordinator!
    var navigationControllerMock: NavigationControllerMock! {
        return sut.navigationController as? NavigationControllerMock
    }
    var characterManagerMock: TelevisionCharacterManaging!
    
    override func setUp() {
        sut = AppCoordinator(app: .simpsons, navigationController: NavigationControllerMock())
        sut.networkManager = NetworkManagerMock(session: URLSessionMock())
        sut.characterManager = TelevisionCharacterManager(networkManager: sut.networkManager)
        sut.imageManager = ImageManagerMock(networkManagerMock: sut.networkManager)
        characterManagerMock = TelevisionCharacterManager(networkManager: NetworkManagerMock(session: URLSessionMock()))
    }

    override func tearDown() {
        sut = nil
        characterManagerMock = nil
    }
    
    func test_start_ShouldPushCharacterListViewOntoStack() {
        sut.start()
    
        XCTAssertTrue(navigationControllerMock.pushedViewController is CharacterListViewController)
    }
    
    func test_userDidSelectRow_CompactSizeClassViewControllerGiven_ShouldPushDetailViewController() {
        let vc = CharacterListViewControllerkWidthCompactMock()
        vc.characterListViewModel = CharacterListViewModelMock(characterManager: characterManagerMock, app: .theWire)
        navigationControllerMock.pushViewController(vc, animated: true)
        
        XCTAssertTrue(navigationControllerMock.topViewController is CharacterListViewControllerkWidthCompactMock)
        
        sut.userDidSelectRow(at: IndexPath(item: 0, section: 0), on: vc)
        
        XCTAssertTrue(navigationControllerMock.topViewController is CharacterDetailViewController)
    }
    
    func test_userDidSelectRow_RegularSizeClassViewControllerGiven_ShouldUpdateChildViewControllerViews() {
        let vc = CharacterListViewControllerkWidthRegularMock()
        vc.characterListViewModel = CharacterListViewModelMock(characterManager: characterManagerMock, app: .theWire)
        
        let detailVC = CharacterDetailViewControllerMock()
        detailVC.loadViewIfNeeded()
        vc.addChild(detailVC)
        
        navigationControllerMock.pushViewController(vc, animated: true)
        
        XCTAssertTrue(navigationControllerMock.topViewController is CharacterListViewControllerkWidthRegularMock)
        
        sut.userDidSelectRow(at: IndexPath(item: 0, section: 0), on: vc)
        
        XCTAssertTrue(navigationControllerMock.topViewController is CharacterListViewControllerkWidthRegularMock)
        
        guard let childDetailVC = vc.children.first as? CharacterDetailViewControllerMock else { XCTFail("Failed to cast child") ; return }
        
        XCTAssertTrue(childDetailVC.updateLabelsWasCalled)
        XCTAssertTrue(childDetailVC.updateImageWasCalled)
    }
    
    func test_searchBarTextDidChange_TextGiven_ShouldUpdateCharactersArray() {
        guard let listViewController = UIStoryboard.characterViewerMain.instantiateViewController(withIdentifier: "CharacterListViewController") as? CharacterListViewController else { XCTFail("Failed to cast list vc") ; return }
        _ = listViewController.view
        let listViewModel = CharacterListViewModelMock(characterManager: sut.characterManager, app: .simpsons)
        listViewController.characterListViewModel = listViewModel
        
        sut.searchBar(textDidChange: "Gav", on: listViewController, listViewModel: listViewModel)
        
        XCTAssertEqual(listViewController.characterListViewModel?.characters.count, 1)
        XCTAssertEqual(listViewController.characterListViewModel?.characters.first?.text, "Gavin Belsin")
    }
    
    func test_characterDetailViewDidLoad_ShouldCallUpdateDetailViewControllerViews() {
        let characterDetailViewControllerMock = CharacterDetailViewControllerMock()
        
        let character = TelevisionCharacter(text: "Russ Hanaman", icon: Icon(urlString: "Tres Commas Club"))
        let characterDetailViewModel = CharacterDetailViewModel(model: character)
        sut.characterDetailViewDidLoad(viewController: characterDetailViewControllerMock, viewModel: characterDetailViewModel)
        
        XCTAssertTrue(characterDetailViewControllerMock.updateLabelsWasCalled)
        XCTAssertTrue(characterDetailViewControllerMock.updateImageWasCalled)
    }
}

class CharacterListViewControllerkWidthCompactMock: CharacterListViewController {
    override var traitCollection: UITraitCollection {
        return UITraitCollection(horizontalSizeClass: UIUserInterfaceSizeClass.compact)
    }
}

class CharacterListViewControllerkWidthRegularMock: CharacterListViewController {
    override var traitCollection: UITraitCollection {
        return UITraitCollection(horizontalSizeClass: UIUserInterfaceSizeClass.regular)
    }
}

class CharacterDetailViewControllerMock: CharacterDetailViewController {
    var updateLabelsWasCalled = false
    var updateImageWasCalled = false
    
    override func updateLabels(with characterDetailViewModel: CharacterDetailViewModel) {
        updateLabelsWasCalled = true
    }
    
    override func updateImageView(with image: UIImage) {
        updateImageWasCalled = true
    }
}
