//
//  CharacterManager.swift
//  CharacterViewer
//
//  Created by Frank Martin Jr on 11/20/19.
//  Copyright © 2019 FrankMartin. All rights reserved.
//

import Foundation

enum TelevisionCharacterAPIEndPoint: String {
    case simpsons = "http://api.duckduckgo.com/?q=simpsons+characters&format=json"
    case theWire = "http://api.duckduckgo.com/?q=the+wire+characters&format=json"
}

enum TelevisionCharacterAPIError: Error {
    case invalidURL
    case decodingError
    case generic
}


protocol TelevisionCharacterManaging {
    var networkManager: NetworkManaging { get set }
    func fetchCharacters(from endpoint: TelevisionCharacterAPIEndPoint, completion: @escaping (Result<[TelevisionCharacter], TelevisionCharacterAPIError>) -> Void)
}

class TelevisionCharacterManager: TelevisionCharacterManaging {
    var networkManager: NetworkManaging
    
    init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
    }
    
    func fetchCharacters(from endpoint: TelevisionCharacterAPIEndPoint, completion: @escaping (Result<[TelevisionCharacter], TelevisionCharacterAPIError>) -> Void) {
        guard let url = URL(string: endpoint.rawValue) else { completion(.failure(.invalidURL)); return }
        networkManager.fetchObjects(fromURL: url) { (result) in
            switch result {
            case .success(let data):
                do {
                    let topLevelDictionary = try JSONDecoder().decode(TopLevelDictionary.self, from: data)
                    let televisionCharacters = topLevelDictionary.televisionCharacters
                    completion(.success(televisionCharacters))
                } catch {
                    completion(.failure(.decodingError))
                }
            // FIXME: -  **** Error handling ****
            case .failure(_):
                completion(.failure(.generic))
            }
        }
    }
}
