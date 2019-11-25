//
//  Coordinator.swift
//  CharacterViewer
//
//  Created by Frank Martin Jr on 11/21/19.
//  Copyright © 2019 FrankMartin. All rights reserved.
//

import UIKit

class AppCoordinator {
    let navigationController: UINavigationController
    let app: TelevisionCharacterApp
    var networkManager: NetworkManaging
    var characterManager: TelevisionCharacterManaging
    var imageManager: ImageManaging

    init(app: TelevisionCharacterApp, navigationController: UINavigationController) {
        self.app = app
        self.navigationController = navigationController
        self.networkManager = NetworkManager(session: URLSession.shared)
        self.characterManager = TelevisionCharacterManager(networkManager: networkManager)
        self.imageManager = ImageManager(networkManager: networkManager)
    }
    
    func start() {
        guard let characterListViewController = UIStoryboard.characterViewerMain.instantiateViewController(withIdentifier: "CharacterListViewController") as? CharacterListViewController else { return }
        let characterListViewModel = CharacterListViewModel(characterManager: characterManager,
                                                            app: app)
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
            guard let detailVC = viewController.children.first as? CharacterDetailViewController else { return }
            if app == .theWire {
                detailVC.characterImageView.contentMode = .scaleAspectFill
            }
            detailVC.updateLabels(with: characterDetailViewModel)
            if let imageURL = characterDetailViewModel.imageURL {
                imageManager.fetchImage(from: imageURL) { (result) in
                    switch result {
                    case .success(let image):
                        detailVC.updateImageView(with: image)
                    case .failure(_):
                        detailVC.updateImageView(with: UIImage(named: "NotFound") ?? UIImage())
                    }
                }
            } else {
                detailVC.updateImageView(with: UIImage(named: "NotFound") ?? UIImage())
            }
        }
    }
    
    func searchBar(textDidChange searchText: String, on viewController: CharacterListViewController, listViewModel: CharacterListViewModel) {
        guard searchText != "" else {
            listViewModel.characters = listViewModel.allCharacters
            viewController.tableView.reloadData()
            return
        }
        listViewModel.characters = listViewModel.allCharacters.filter { $0.text.contains(searchText) }
        viewController.tableView.reloadData()
    }
}

extension AppCoordinator: CharacterDetailViewControllerDelegate {
    func characterDetailViewDidLoad(viewController: CharacterDetailViewController, viewModel: CharacterDetailViewModel) {
        viewController.updateLabels(with: viewModel)
        guard let imageURL = viewModel.imageURL else {
            viewController.updateImageView(with: UIImage(named: "NotFound") ?? UIImage())
            return
        }
        imageManager.fetchImage(from: imageURL) { [weak self] (result) in
            switch result {
            case .success(let image):
                if self?.app == .theWire {
                    DispatchQueue.main.async {
                        viewController.characterImageView.contentMode = .scaleAspectFill
                    }
                }
                viewController.updateImageView(with: image)
            case .failure(_):
                viewController.updateImageView(with: UIImage(named: "NotFound") ?? UIImage())
            }
        }
    }
}
