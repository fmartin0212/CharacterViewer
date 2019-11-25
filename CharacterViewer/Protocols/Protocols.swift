//
//  Protocols.swift
//  CharacterViewer
//
//  Created by Frank Martin Jr on 11/24/19.
//  Copyright © 2019 FrankMartin. All rights reserved.
//

import Foundation

protocol NetworkTask {
    func resume()
}

extension URLSessionDataTask: NetworkTask {}

protocol NetworkSession {
    func dataTask(with url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkTask
}

extension URLSession: NetworkSession {
    func dataTask(with url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkTask {
        return dataTask(with: url, completionHandler: completion)
    }
}
