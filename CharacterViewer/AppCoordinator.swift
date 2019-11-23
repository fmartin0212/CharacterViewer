//
//  Coordinator.swift
//  CharacterViewer
//
//  Created by Frank Martin Jr on 11/21/19.
//  Copyright © 2019 FrankMartin. All rights reserved.
//

import UIKit

protocol Coordinator {
    
}

class AppCoordinator: Coordinator {
    let navigationController: UINavigationController
    let endpoint: TelevisionCharacterAPIEndPoint
    let dependencies: Dependencies
    
    struct Dependencies {
        let networkManager = NetworkManager()
        var characterManager: TelevisionCharacterManager {
            return TelevisionCharacterManager(networkManager: networkManager) }
        var imageManager: ImageManager {
            return ImageManager(networkManager: networkManager)
        }
    }
    
    init(endpoint: TelevisionCharacterAPIEndPoint) {
        self.navigationController = UINavigationController()
        self.endpoint = endpoint
        self.dependencies = Dependencies()
    }
    
    func start() {
        guard let characterListViewController = UIStoryboard.characterViewerMain.instantiateViewController(withIdentifier: "CharacterListViewController") as? CharacterListViewController else { return }
        let characterListViewModel = CharacterListViewModel(characterManager: dependencies.characterManager,
                                                            endpoint: endpoint)
        characterListViewController.characterListViewModel = characterListViewModel
        characterListViewController.coordinatorDelegate = self
        navigationController.pushViewController(characterListViewController, animated: true)
    }
}

extension AppCoordinator: CharacterListViewControllerCoordinatorDelegate {
    func userDidSelectRow(at indexPath: IndexPath, on viewController: CharacterListViewController) {
        guard let character = viewController.characterListViewModel?.characters[indexPath.row] else { return }
        let characterDetailViewModel = CharacterDetailViewModel(model: character)
        
        let horSizeClass = viewController.traitCollection.horizontalSizeClass
        if horSizeClass == .compact {
            guard let characterDetailViewController = UIStoryboard.characterViewerMain.instantiateViewController(withIdentifier: "CharacterDetailViewController") as? CharacterDetailViewController else { return }
            characterDetailViewController.characterDetailViewModel = characterDetailViewModel
            characterDetailViewController.coordinatorDelegate = self
            navigationController.pushViewController(characterDetailViewController, animated: true)
        } else {
            viewController.updateLabels(with: characterDetailViewModel)
            if let imageURL = characterDetailViewModel.imageURL {
                dependencies.imageManager.fetchImage(from: imageURL) { (result) in
                    switch result {
                    case .success(let image):
                        viewController.updateImageView(with: image)
                    case .failure(_):
                        viewController.updateImageView(with: UIImage(named: "NotFound") ?? UIImage())
                    }
                }
            } else {
                viewController.updateImageView(with: UIImage(named: "NotFound") ?? UIImage())
            }
        }
    }
}

extension AppCoordinator: CharacterDetailViewControllerDelegate {
    func viewDidLoad(viewController: CharacterDetailViewController, viewModel: CharacterDetailViewModel) {
        viewController.updateLabels(with: viewModel)
        guard let imageURL = viewModel.imageURL else {
            viewController.updateImageView(with: UIImage(named: "NotFound") ?? UIImage())
            return
        }
        dependencies.imageManager.fetchImage(from: imageURL) { (result) in
            switch result {
            case .success(let image):
                viewController.updateImageView(with: image)
            case .failure(_):
                viewController.updateImageView(with: UIImage(named: "NotFound") ?? UIImage())
            }
        }
    }
}
