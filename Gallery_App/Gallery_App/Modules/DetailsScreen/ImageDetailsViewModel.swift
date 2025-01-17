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
    private var dataManager: DataManagerProtocol
    private var networkManager: NetworkManagerProtocol
    weak var delegate: ImageDetailsViewModelDelegate?
    
    init(images: [Image], imageIndex: Int, dataManager: DataManagerProtocol = DataManager(), networkManager: NetworkManager = NetworkManager()) {
        self.images = images
        self.imageIndex = imageIndex
        self.dataManager = dataManager
        self.networkManager = networkManager
        favouriteImages = dataManager.fetchFavouriteImages()
    }
    
    func updateHeartButtonImage() {
        let id = images[imageIndex].id
        if favouriteImages.contains(where: { $0.id == id }) {
            delegate?.markAsFavourite()
        } else {
            delegate?.removeFavouriteMark()
        }
    }
    
    func addImageToFavourite() {
        let image = images[imageIndex]
        favouriteImages.append(image)
        dataManager.saveFavouriteImages(favouriteImages)
    }
    
    func removeImageFromFavourite() {
        let id = images[imageIndex].id
        favouriteImages.removeAll(where: { $0.id == id })
        dataManager.saveFavouriteImages(favouriteImages)
    }
}

extension ImageDetailsViewModel: ImageDetailsViewModelProtocol {
    func fetchImage() {
        let urlString = images[imageIndex].urls.regular
        networkManager.fetchData(with: urlString) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let imageDescription = self.images[self.imageIndex].alt_description
                    self.delegate?.updateImageDetails(with: data, and: imageDescription)
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
        let id = images[imageIndex].id
        if favouriteImages.contains(where: { $0.id == id }) {
            removeImageFromFavourite()
            delegate?.removeFavouriteMark()
        } else {
            addImageToFavourite()
            delegate?.markAsFavourite()
        }
    }
}
