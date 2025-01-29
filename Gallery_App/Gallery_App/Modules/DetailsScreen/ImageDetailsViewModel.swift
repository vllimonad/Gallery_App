//
//  ImageDetailsViewModel.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 28/11/2024.
//

import Foundation

protocol ImageDetailsViewModelProtocol {
    func fetchImage()
    func swipedRight()
    func swipedLeft()
    func heartButtonPressed()
}

final class ImageDetailsViewModel {
    private var images: [Image]
    private var favouriteImages = [Image]()
    private var imageIndex: Int
    private var mapper: ImageMapper
    private var dataManager: CoreDataManagerProtocol
    private var networkManager: NetworkManagerProtocol
    weak var delegate: ImageDetailsViewModelDelegate?
    
    init(images: [Image], mapper: ImageMapper = ImageMapper(), imageIndex: Int, dataManager: CoreDataManagerProtocol = CoreDataManager(), networkManager: NetworkManager = NetworkManager()) {
        self.images = images
        self.imageIndex = imageIndex
        self.mapper = mapper
        self.dataManager = dataManager
        self.networkManager = networkManager
        favouriteImages = dataManager.fetchImages()
    }

    func isImageFavourite() -> Bool {
        let id = images[imageIndex].id
        return favouriteImages.contains(where: { $0.id == id })
    }
    
    func addImageToFavourite() {
        let image = images[imageIndex]
        dataManager.insertImage(image)
        favouriteImages.append(image)
    }
    
    func removeImageFromFavourite() {
        let id = images[imageIndex].id
        guard let image = favouriteImages.first(where: { $0.id == id }) else { return }
        dataManager.deleteImage(image)
        favouriteImages.removeAll(where: { $0.id == id })
    }
    
    func updateHeartButtonImage() {
        if isImageFavourite() {
            delegate?.markAsFavourite()
        } else {
            delegate?.removeFavouriteMark()
        }
    }
    
    func updateImage(with data: Data) {
        let imageDescription = images[imageIndex].title
        delegate?.updateImageDetails(with: data, and: imageDescription)
    }
}

extension ImageDetailsViewModel: ImageDetailsViewModelProtocol {
    func fetchImage() {
        let urlString = images[imageIndex].regularUrl
        networkManager.fetchData(with: urlString) { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async { [weak self] in
                    self?.updateImage(with: data)
                    self?.updateHeartButtonImage()
                }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.showAlert(error)
                }
            }
        }
    }
    
    func swipedRight() {
        guard imageIndex > 0 else { return }
        imageIndex -= 1
    }
    
    func swipedLeft() {
        guard imageIndex < images.count - 1 else { return }
        imageIndex += 1
    }
    
    func heartButtonPressed() {
        if isImageFavourite() {
            removeImageFromFavourite()
            delegate?.removeFavouriteMark()
        } else {
            addImageToFavourite()
            delegate?.markAsFavourite()
        }
    }
}
