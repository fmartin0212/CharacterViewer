//
//  CharacterDetailViewController.swift
//  CharacterViewer
//
//  Created by Frank Martin Jr on 11/20/19.
//  Copyright © 2019 FrankMartin. All rights reserved.
//

import UIKit

class CharacterDetailViewController: UIViewController {

    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterTitleLabel: UILabel!
    @IBOutlet weak var characterDescriptionLabel: UILabel!
    var characterDetailViewModel: CharacterDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}
