//
//  CharacterListViewModel.swift
//  CharacterViewer
//
//  Created by Frank Martin Jr on 11/21/19.
//  Copyright © 2019 FrankMartin. All rights reserved.
//

import Foundation

class CharacterDetailViewModel {
    private var model: TelevisionCharacter
    
    init(model: TelevisionCharacter) {
        self.model = model
    }
    
    var title: String {
        guard let dashIndex = model.text.firstIndex(of: "-") else { return "" }
        return String(model.text.prefix(upTo: dashIndex))
    }
    
    var description: String {
        guard let dashIndex = model.text.firstIndex(of: "-") else { return "" }
        let startingIndex = model.text.index(dashIndex, offsetBy: 2)
        return String(model.text.suffix(from: startingIndex))
    }
}
