//
//  CharacterManager.swift
//  CharacterViewer
//
//  Created by Frank Martin Jr on 11/20/19.
//  Copyright © 2019 FrankMartin. All rights reserved.
//

import Foundation

protocol MovieCharacterManaging {
    var networkManager: NetworkManaging { get set }
    func getCharacters(fromURL url: URL, completion: @escaping (Result<[TelevisionCharacter], CharacterAPIError>) -> Void)
}

enum CharacterAPIError: Error {
    case decodingError
    case generic
}

class MovieCharacterManager: MovieCharacterManaging {
    var networkManager: NetworkManaging
    
    init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
    }
    
    func getCharacters(fromURL url: URL, completion: @escaping (Result<[TelevisionCharacter], CharacterAPIError>) -> Void) {
        networkManager.fetchObjects(fromURL: url) { (result) in
            switch result {
            case .success(let data):
                do {
                    let topLevelDictionary = try JSONDecoder().decode(TopLevelDictionary.self, from: data)
                    let movieCharacters = topLevelDictionary.movieCharacters
                    completion(.success(movieCharacters))
                } catch {
                    completion(.failure(.decodingError))
                }
            case .failure(let _):
                completion(.failure(.generic))
            }
        }
    }
    
    
}
