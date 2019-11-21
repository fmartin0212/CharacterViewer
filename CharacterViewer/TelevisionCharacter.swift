//
//  MovieCharacter.swift
//  CharacterViewer
//
//  Created by Frank Martin Jr on 11/20/19.
//  Copyright © 2019 FrankMartin. All rights reserved.
//

import Foundation

struct TopLevelDictionary: Decodable {
    let movieCharacters: [TelevisionCharacter]
    
    enum CodingKeys: String, CodingKey {
        case movieCharacters = "RelatedTopics"
    }
}

struct TelevisionCharacter: Decodable {
    let title: String
    let description: String
    let icon: Icon?
    var imageURLString: String? {
        return icon?.urlString
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case icon = "Icon"
    }
}

struct Icon: Decodable {
    let urlString: String
    
    enum CodingKeys: String, CodingKey {
        case urlString = "URL"
    }
}


