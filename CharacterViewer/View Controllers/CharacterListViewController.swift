//
//  CharacterListViewController.swift
//  CharacterViewer
//
//  Created by Frank Martin Jr on 11/20/19.
//  Copyright © 2019 FrankMartin. All rights reserved.
//

import UIKit

protocol CharacterListViewControllerCoordinatorDelegate: class {
    func userDidSelectRow(at indexPath: IndexPath, on viewController: CharacterListViewController)
}

class CharacterListViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var characterDetailStackView: UIStackView!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterTitleLabel: UILabel!
    @IBOutlet weak var characterDescriptionLabel: UILabel!
    var characterListViewModel: CharacterListViewModel?
    var coordinatorDelegate: CharacterListViewControllerCoordinatorDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        guard let characterListViewModel = characterListViewModel else { return }
        characterListViewModel.fetchCharacters(completion: { (error) in
            if let error = error {
                print("do something")
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
            }
        })
    }
}

extension CharacterListViewController {
    func updateLabels(with characterDetailViewModel: CharacterDetailViewModel) {
        DispatchQueue.main.async { [weak self] in
        self?.characterTitleLabel.text = characterDetailViewModel.title
        self?.characterDescriptionLabel.text = characterDetailViewModel.description
        }
    }
    
    func updateImageView(with image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            self?.characterImageView.image = image
        }
    }
}

extension CharacterListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterListViewModel?.characters.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath)
        guard let character = characterListViewModel?.characters[indexPath.row] else { return UITableViewCell() }
        let characterDetailViewModel = CharacterDetailViewModel(model: character)
        cell.textLabel?.text = characterDetailViewModel.title
        return cell
    }
}

extension CharacterListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinatorDelegate?.userDidSelectRow(at: indexPath, on: self)
    }
}
