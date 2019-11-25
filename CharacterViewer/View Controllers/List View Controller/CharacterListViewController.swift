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
    func searchBar(textDidChange searchText: String, on viewController: CharacterListViewController, listViewModel: CharacterListViewModel)
}

class CharacterListViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var characterListViewModel: CharacterListViewModel?
    var coordinatorDelegate: CharacterListViewControllerCoordinatorDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        guard let characterListViewModel = characterListViewModel else { return }
        characterListViewModel.fetchCharacters(completion: { (error) in
            if error != nil {
                DispatchQueue.main.async { [weak self] in
                    let alert = UIAlertController.genericError()
                    self?.present(alert, animated: true, completion: nil)
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
            }
        })
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

extension CharacterListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let listViewModel = characterListViewModel else { return }
        coordinatorDelegate?.searchBar(textDidChange: searchText, on: self, listViewModel: listViewModel)
    }
}
