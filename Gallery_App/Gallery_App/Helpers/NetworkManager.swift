//
//  NetworkService.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 28/11/2024.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchData(with urlString: String, completion: @escaping (Result<Data,Error>) -> Void)
}

final class NetworkManager {}

extension NetworkManager: NetworkManagerProtocol {
    func fetchData(with urlString: String, completion: @escaping (Result<Data, any Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            completion(.success(data))
        }.resume()
    }
}
