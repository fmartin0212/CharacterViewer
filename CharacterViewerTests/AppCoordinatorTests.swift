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
    
    override func setUp() {
        sut = AppCoordinator(app: .simpsons)
    }

    override func tearDown() {
    }

   
}
