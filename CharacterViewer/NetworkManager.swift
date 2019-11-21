//
//  NetworkManager.swift
//  CharacterViewer
//
//  Created by Frank Martin Jr on 11/20/19.
//  Copyright © 2019 FrankMartin. All rights reserved.
//

import Foundation

protocol NetworkManaging: class {
    func fetchCharacters(completion: @escaping (MovieCharacter?) -> Void)
}

class NetworkManager: NetworkManaging {t
    func fetchCharacters(completion: @escaping (MovieCharacter?) -> Void) {
        guard let url = URL(string: baseURLString) else { completion(nil) ; return }
        
    }
}
