//
//  NetworkManager.swift
//  CharacterViewer
//
//  Created by Frank Martin Jr on 11/20/19.
//  Copyright © 2019 FrankMartin. All rights reserved.
//

import Foundation

protocol NetworkManaging: class {
    func fetchObjects<T: Decodable>(fromURL url: URL, completion: @escaping ([T]?) -> Void)
}

//protocol NetworkSession {
//    func dataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkTask
//    func dataTask(with url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkTask
//}
//
//protocol NetworkTask: URLSessionDataTask {}
//
//extension URLSession: NetworkSession {
//    func dataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkTask {
//        return NetworkTask()
//    }
//
//    func dataTask(with url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkTask {
//
//    }
//}

class NetworkManager: NetworkManaging {
    func fetchObjects<T: Decodable>(fromURL url: URL, completion: @escaping ([T]?) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error)
            }
            guard let data = data else { completion(nil) ; return }
            do {
                let objects = try JSONDecoder().decode([T].self, from: data)
                completion(objects)
            } catch {
                print(error)
                completion(nil)
            }
        }
        dataTask.resume()
    }
}
