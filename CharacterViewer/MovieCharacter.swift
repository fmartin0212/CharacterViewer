//
//  MovieCharacter.swift
//  CharacterViewer
//
//  Created by Frank Martin Jr on 11/20/19.
//  Copyright © 2019 FrankMartin. All rights reserved.
//

import Foundation

protocol MovieCharacter {
    var title: String { get set }
    var description: String { get set }
    var imageURLString: String { get set }
}
