//
//  ImageManager.swift
//  CharacterViewer
//
//  Created by Frank Martin Jr on 11/21/19.
//  Copyright © 2019 FrankMartin. All rights reserved.
//

import UIKit

enum ImageManagerError: Error {
    case generic
    case corruptData
}

protocol ImageManaging {
    var networkManager: NetworkManaging { get set }
    
}

class ImageManager: ImageManaging {
    var networkManager: NetworkManaging
    
    init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
    }
    
    func fetchImage(from url: URL, completion: @escaping (Result<UIImage, ImageManagerError>) -> Void) {
        networkManager.fetch(from: url) { (result) in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else { completion(.failure(.corruptData)) ; return }
                completion(.success(image))
            case .failure(_):
                completion(.failure(.generic))
            }
        }
    }
}
