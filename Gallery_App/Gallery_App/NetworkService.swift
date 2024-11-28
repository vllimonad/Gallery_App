//
//  NetworkService.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 28/11/2024.
//

import Foundation
class NetworkService {
    private let urlString = "https://api.unsplash.com/photos?page=1&per_page=30&client_id=1NCPQEX5juLF1PEgNi2TITI-XXtZVnEpKyqGCgLU1KA"
    static let shared = NetworkService()
    
    private init() {}
    
    func fetchImages(completion: @escaping (Result<Data,Error>) -> Void) {
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
