//
//  ImageDetailsViewModel.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 28/11/2024.
//

import Foundation
final class ImageDetailsViewModel {
    private var images: [Image]
    private var imageIndex: Int
    weak var delegate: ImageDetailsViewModelDelegate!
    
    init(images: [Image], imageIndex: Int) {
        self.images = images
        self.imageIndex = imageIndex
    }
    
    private func updateHeartButtonImage() {
        let id = images[imageIndex].id
        if DataManager.shared.favouriteImagesIds.contains(id) {
            delegate.markAsFavourite()
        } else {
            delegate.removeFavouriteMark()
        }
    }
}

extension ImageDetailsViewModel: ImageDetailsViewModelProtocol {
    func fetchImage() {
        let urlString = images[imageIndex].urls.regular
        NetworkManager.shared.fetchData(with: urlString) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let imageDescription = self.images[self.imageIndex].alt_description
                    self.delegate.updateImageDetails(with: data, and: imageDescription)
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
        guard imageIndex > 0 else { return }
        imageIndex -= 1
        fetchImage()
    }
    
    func swipedLeft() {
        guard imageIndex < images.count - 1 else { return }
        imageIndex += 1
        fetchImage()
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
