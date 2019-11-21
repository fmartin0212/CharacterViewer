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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
