//
//  MovieCharacter.swift
//  CharacterViewer
//
//  Created by Frank Martin Jr on 11/20/19.
//  Copyright © 2019 FrankMartin. All rights reserved.
//

import Foundation

struct TopLevelDictionary: Decodable {
    var televisionCharacters: [TelevisionCharacter]
    
    enum CodingKeys: String, CodingKey {
        case televisionCharacters = "RelatedTopics"
    }
}

struct TelevisionCharacter: Decodable {
    var text: String
    let icon: Icon?
    var imageURLString: String? {
        return icon?.urlString
    }
    
    enum CodingKeys: String, CodingKey {
        case text = "Text"
        case icon = "Icon"
    }
}

struct Icon: Decodable {
    let urlString: String
    
    enum CodingKeys: String, CodingKey {
        case urlString = "URL"
    }
}


