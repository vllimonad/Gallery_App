//
//  ImageViewCellViewModel.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 19/01/2025.
//

import Foundation
protocol ImageViewCellViewModelProtocol {
    func loadImage()
}

class ImageViewCellViewModel {
    private var networkManager: NetworkManagerProtocol
    private var image: Image
    weak var delegate: ImageViewCellViewModelDelegate?
    
    init(image: Image, networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.image = image
        self.networkManager = networkManager
    }
}

extension ImageViewCellViewModel: ImageViewCellViewModelProtocol {
    func loadImage() {
        let urlString = image.thumbUrl
        networkManager.fetchData(with: urlString) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.delegate?.showImage(data)
                }
            case .failure:
                DispatchQueue.main.async {
                    self.delegate?.showError()
                }
            }
        }
    }
}
