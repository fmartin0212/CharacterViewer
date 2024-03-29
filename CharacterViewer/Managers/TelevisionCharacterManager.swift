//
//  CharacterManager.swift
//  CharacterViewer
//
//  Created by Frank Martin Jr on 11/20/19.
//  Copyright © 2019 FrankMartin. All rights reserved.
//

import Foundation

enum TelevisionCharacterApp: String {
    case simpsons = "http://api.duckduckgo.com/?q=simpsons+characters&format=json"
    case theWire = "http://api.duckduckgo.com/?q=the+wire+characters&format=json"
    
    var endpoint: URL? {
        switch self {
        case .simpsons:
            return URL(string: "http://api.duckduckgo.com/?q=simpsons+characters&format=json")
        case .theWire:
            return URL(string: "http://api.duckduckgo.com/?q=the+wire+characters&format=json")
        }
    }
}

enum TelevisionCharacterAPIError: Error {
    case invalidURL
    case decodingError
    case generic
}

protocol TelevisionCharacterManaging {
    var networkManager: NetworkManaging { get set }
    func fetchCharacters(for app: TelevisionCharacterApp, completion: @escaping (Result<[TelevisionCharacter], TelevisionCharacterAPIError>) -> Void)
}

class TelevisionCharacterManager: TelevisionCharacterManaging {
    var networkManager: NetworkManaging
    
    init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
    }
    
    func fetchCharacters(for app: TelevisionCharacterApp, completion: @escaping (Result<[TelevisionCharacter], TelevisionCharacterAPIError>) -> Void) {
        guard let url = app.endpoint else { completion(.failure(.invalidURL)); return }
        networkManager.fetch(from: url) { (result) in
            switch result {
            case .success(let data):
                do {
                    let topLevelDictionary = try JSONDecoder().decode(TopLevelDictionary.self, from: data)
                    let televisionCharacters = topLevelDictionary.televisionCharacters
                    completion(.success(televisionCharacters))
                } catch {
                    completion(.failure(.decodingError))
                }
            case .failure(_):
                completion(.failure(.generic))
            }
        }
    }
}
