//
//  TestMocks.swift
//  CharacterViewerTests
//
//  Created by Frank Martin Jr on 11/23/19.
//  Copyright © 2019 FrankMartin. All rights reserved.
//

import Foundation

class NetworkManagerMock: NetworkManaging {
    private struct Constants {
        static let SimpsonsURL = "http://api.duckduckgo.com/?q=simpsons+characters&format=json"
        static let TheWireURL = "http://api.duckduckgo.com/?q=the+wire+characters&format=json"
        static let SimpsonsDataFilename = "SimpsonsData"
        static let TheWireDataFilename = "TheWireData"
    }
    
    func fetch(from url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        switch url.absoluteString {
            
        case Constants.SimpsonsURL:
            let data = loadJsonFrom(fileName: Constants.SimpsonsDataFilename)
            completion(.success(data))
            
        case Constants.TheWireURL:
            let data = loadJsonFrom(fileName: Constants.TheWireDataFilename)
            completion(.success(data))
        default:
            return
        }
    }
    
    func loadJsonFrom(fileName: String) -> Data {
        let path = Bundle.main.path(forResource: fileName, ofType: "json")
        let jsonData = try! Data(contentsOf: URL(fileURLWithPath: path!))
        return jsonData
    }
}