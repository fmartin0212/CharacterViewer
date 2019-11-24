//
//  Extensions.swift
//  CharacterViewer
//
//  Created by Frank Martin Jr on 11/21/19.
//  Copyright © 2019 FrankMartin. All rights reserved.
//

import UIKit

extension UIStoryboard {
    static let characterViewerMain = UIStoryboard(name: "Main", bundle: nil)
}

extension UIAlertController {
    static func genericError() -> UIAlertController {
        let alertC = UIAlertController(title: "Something went wrong.", message: "Please try again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertC.addAction(okAction)
        return alertC
    }
}
