//
//  ImageViewCellViewModel.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 19/01/2025.
//

import Foundation
protocol ImageViewCellViewModelProtocol {
    func loadImage(with urlString: String)
}

class ImageViewCellViewModel {
    private var networkManager: NetworkManagerProtocol
    weak var delegate: ImageViewCellViewModelDelegate?
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
}

extension ImageViewCellViewModel: ImageViewCellViewModelProtocol {
    func loadImage(with urlString: String) {
        networkManager.fetchData(with: urlString) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.delegate?.showImage(data)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.showError()
                }
            }
        }
    }
}
