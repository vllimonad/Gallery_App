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
    private var images: [FetchedImage]
    private var favouriteImages = [ImageEntity]()
    private var imageIndex: Int
    private var dataManager: CoreDataManagerProtocol
    private var networkManager: NetworkManagerProtocol
    weak var delegate: ImageDetailsViewModelDelegate?
    
    init(images: [FetchedImage], imageIndex: Int, dataManager: CoreDataManagerProtocol = CoreDataManager(), networkManager: NetworkManager = NetworkManager()) {
        self.images = images
        self.imageIndex = imageIndex
        self.dataManager = dataManager
        self.networkManager = networkManager
        favouriteImages = dataManager.fetchImages()
    }

    func isImageFavourite() -> Bool {
        let id = images[imageIndex].id
        return favouriteImages.contains(where: { $0.id == id })
    }
    
    func addImageToFavourite() {
        guard let imageEntity = dataManager.saveImage(images[imageIndex]) else { return }
        favouriteImages.append(imageEntity)
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
        let imageDescription = images[imageIndex].alt_description
        delegate?.updateImageDetails(with: data, and: imageDescription)
    }
}

extension ImageDetailsViewModel: ImageDetailsViewModelProtocol {
    func fetchImage() {
        let urlString = images[imageIndex].urls.regular
        networkManager.fetchData(with: urlString) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.updateImage(with: data)
                    self.updateHeartButtonImage()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.showAlert(error)
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
