//
//  CharacterListViewModel.swift
//  CharacterViewer
//
//  Created by Frank Martin Jr on 11/21/19.
//  Copyright © 2019 FrankMartin. All rights reserved.
//

import Foundation

class CharacterListViewModel {
    let characterManager: TelevisionCharacterManaging
    let app: TelevisionCharacterApp
    var allCharacters = [TelevisionCharacter]()
    var characters = [TelevisionCharacter]()
    var filteredList = [TelevisionCharacter]()
    
    init(characterManager: TelevisionCharacterManaging, app: TelevisionCharacterApp) {
        self.characterManager = characterManager
        self.app = app
    }
    
    func fetchCharacters(completion: @escaping (TelevisionCharacterAPIError?) -> Void) {
        characterManager.fetchCharacters(for: app) { (result) in
            switch result {
            case .success(let characters):
                self.allCharacters = characters
                self.characters = characters
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
}
