//
//  NetworkManager.swift
//  CharacterViewer
//
//  Created by Frank Martin Jr on 11/20/19.
//  Copyright © 2019 FrankMartin. All rights reserved.
//

import Foundation

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
protocol NetworkManaging: class {
    var session: NetworkSession { get set }
    func fetch(from url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void)
}

enum NetworkError: Error {
    case generic
    case corruptedData
    case apiError(Error)
}

class NetworkManager: NetworkManaging {
    
    var session: NetworkSession
    
    init(session: NetworkSession) {
        self.session = session
    }
    
    func fetch(from url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        session.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(.failure(.apiError(error)))
            }
            guard let data = data else { completion(.failure(.corruptedData)) ; return }
            completion(.success(data))
        }.resume()
    }
}
