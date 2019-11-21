//
//  CharacterListViewController.swift
//  CharacterViewer
//
//  Created by Frank Martin Jr on 11/20/19.
//  Copyright © 2019 FrankMartin. All rights reserved.
//

import UIKit

class CharacterListViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var characterDetailStackView: UIStackView!
    
    var televisionCharacterEndpoint: TelevisionCharacterAPIEndPoint?
    var characters = [TelevisionCharacter]()
    var characterManager = TelevisionCharacterManager(networkManager: NetworkManager())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        guard let endp = televisionCharacterEndpoint else { return }
        characterManager.fetchCharacters(from: endp) { (result) in
            switch result {
            case .success(let chars):
                self.characters = chars
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
            case .failure(_):
                return
            }
        }
        
    }
}

extension CharacterListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath)
        let character = characters[indexPath.row]
        cell.textLabel?.text = character.description
        return cell
    }
}

extension CharacterListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let traits = self.traitCollection.horizontalSizeClass
        if traits == .compact {
            let vc = UIStoryboard.characterViewerMain.instantiateViewController(withIdentifier: "CharacterDetailViewController")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
