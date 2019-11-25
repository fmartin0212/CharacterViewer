//
//  TestMocks.swift
//  CharacterViewerTests
//
//  Created by Frank Martin Jr on 11/23/19.
//  Copyright © 2019 FrankMartin. All rights reserved.
//

import UIKit

class NavigationControllerMock: UINavigationController {
    var pushedViewController: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.pushedViewController = viewController
        super.pushViewController(viewController, animated: false)
    }
}

class NetworkManagerMock: NetworkManaging {
    var session: NetworkSession
    
    init(session: NetworkSession) {
        self.session = session
    }
    
    private struct Constants {
        static let SimpsonsURL = "http://api.duckduckgo.com/?q=simpsons+characters&format=json"
        static let TheWireURL = "http://api.duckduckgo.com/?q=the+wire+characters&format=json"
        static let ImageURL = "www.testimageurl.com"
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
        case Constants.ImageURL:
            guard let imageData = UIImage(named: "NotFound")?.pngData() else { completion(.failure(.generic)) ; return }
            completion(.success(imageData))
        default:
            completion(.failure(.generic))
        }
    }
    
    func loadJsonFrom(fileName: String) -> Data {
        let path = Bundle.main.path(forResource: fileName, ofType: "json")
        let jsonData = try! Data(contentsOf: URL(fileURLWithPath: path!))
        return jsonData
    }
}

class ImageManagerMock: ImageManaging {
    var networkManager: NetworkManaging
    
    init(networkManagerMock: NetworkManaging) {
        self.networkManager = networkManagerMock
    }
    
    func fetchImage(from url: URL, completion: @escaping (Result<UIImage, ImageManagerError>) -> Void) {
        completion(.success(UIImage(named: "NotFound") ?? UIImage()))
    }
}

class CharacterListViewModelMock: CharacterListViewModel {
    override init(characterManager: TelevisionCharacterManaging, app: TelevisionCharacterApp) {
        super.init(characterManager: characterManager, app: app)
        self.allCharacters = [TelevisionCharacter(text: "Big Head", icon: nil),
                              TelevisionCharacter(text: "Gavin Belsin", icon: nil),
                              TelevisionCharacter(text: "Russ Hanaman", icon: nil)]
        self.characters = [TelevisionCharacter(text: "Big Head", icon: Icon(urlString: "BigHeadsImageURL")),
                           TelevisionCharacter(text: "Gavin Belsin", icon: nil),
                           TelevisionCharacter(text: "Russ Hanaman", icon: nil)]
    }
}

class URLSessionMock: NetworkSession {
    func dataTask(with url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkTask {
        let data = loadJsonFrom(fileName: "TheWireData")
        completion(data, nil, nil)
        return NetworkTaskMock()
    }
    
    func loadJsonFrom(fileName: String) -> Data {
        let path = Bundle.main.path(forResource: fileName, ofType: "json")
        let jsonData = try! Data(contentsOf: URL(fileURLWithPath: path!))
        return jsonData
    }
}

class NetworkTaskMock: NetworkTask {
    func resume() {}
}

