//
//  CharacterDetailViewController.swift
//  CharacterViewer
//
//  Created by Frank Martin Jr on 11/20/19.
//  Copyright © 2019 FrankMartin. All rights reserved.
//

import UIKit

protocol CharacterDetailViewControllerDelegate: class {
    func viewDidLoad(viewController: CharacterDetailViewController, viewModel: CharacterDetailViewModel)
}

class CharacterDetailViewController: UIViewController {

    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterTitleLabel: UILabel!
    @IBOutlet weak var characterDescriptionLabel: UILabel!
    var coordinatorDelegate: CharacterDetailViewControllerDelegate?
    var characterDetailViewModel: CharacterDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let characterDetailViewModel = characterDetailViewModel else { return }
        coordinatorDelegate?.viewDidLoad(viewController: self, viewModel: characterDetailViewModel)
    }
    
    func updateLabels(with characterDetailViewModel: CharacterDetailViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.characterTitleLabel.text = characterDetailViewModel.title
            self?.characterDescriptionLabel.text = characterDetailViewModel.description
        }
    }
    
    func updateImageView(with image: UIImage) {
        DispatchQueue.main.async { [weak characterImageView] in
            characterImageView?.image = image
        }
    }
}
