//
//  Extensions.swift
//  CharacterViewer
//
//  Created by Frank Martin Jr on 11/21/19.
//  Copyright © 2019 FrankMartin. All rights reserved.
//

import UIKit

extension Bundle {
    static let characterViewer = Bundle(identifier: "com.FrankMartin.CharacterViewer")
}

extension UIStoryboard {
    static let characterViewerMain = UIStoryboard(name: "Main", bundle: Bundle.characterViewer)
}
