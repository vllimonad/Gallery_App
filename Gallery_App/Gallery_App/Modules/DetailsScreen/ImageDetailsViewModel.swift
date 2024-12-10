//
//  ImageDetailsViewModel.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 28/11/2024.
//

import Foundation
class ImageDetailsViewModel {
    private var images: [Image]!
    private var imageIndex: Int!
    weak var delegate: ImageDetailsViewModelDelegate!
    
    private func updateHeartButtonImage() {
        let id = images[imageIndex].id
        if DataManager.shared.favouriteImagesIds.contains(id) {
            delegate.markAsFavourite()
        } else {
            delegate.removeFavouriteMark()
        }
    }
    
    func setImages(_ images: [Image]) {
        self.images = images
    }
    
    func setImageIndex(_ index: Int) {
        imageIndex = index
    }
    
    func getImageUrl() -> String {
        images[imageIndex].urls.regular
    }
}

extension ImageDetailsViewModel: ImageDetailsViewModelProtocol {
    func fetchImage() {
        let urlString = getImageUrl()
        NetworkManager.shared.fetchData(with: urlString) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.delegate.updateImage(data)
                    self.delegate.updateImageDescription(self.images[self.imageIndex].alt_description)
                    self.updateHeartButtonImage()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate.showAlert(error)
                }
            }
        }
    }
    
    func swipedRight() {
        if imageIndex > 0 {
            imageIndex -= 1
            fetchImage()
        }
    }
    
    func swipedLeft() {
        if imageIndex < images.count - 1 {
            imageIndex += 1
            fetchImage()
        }
    }
    
    func heartButtonPressed() {
        let id = images[imageIndex].id
        if DataManager.shared.favouriteImagesIds.contains(id) {
            DataManager.shared.removeFromFavourite(id)
            delegate.removeFavouriteMark()
        } else {
            DataManager.shared.addToFavourite(id)
            delegate.markAsFavourite()
        }
    }
}

protocol ImageDetailsViewModelProtocol {
    func fetchImage()
    func swipedRight()
    func swipedLeft()
    func heartButtonPressed()
}
