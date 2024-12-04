//
//  ImageDetailsViewModel.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 28/11/2024.
//

import Foundation
class ImageDetailsViewModel {
    var images: [ImageInfo]!
    var imageIndex: Int!
    var imageData: Data!
    var updateImage: () -> () = {}
    var markAsFavourite: () -> () = {}
    var removeFavouriteMark: () -> () = {}
    
    func fetchImage(_ imageUrlString: String) {
        NetworkService.shared.fetchData(with: imageUrlString) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.imageData = data
                    self.updateImage()
                    self.check()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func swipedRight() {
        if imageIndex > 0 {
            imageIndex -= 1
            fetchImage(images[imageIndex].urls.regular)
        }
    }
    
    func swipedLeft() {
        if imageIndex < images.count - 1 {
            imageIndex += 1
            fetchImage(images[imageIndex].urls.regular)
        }
    }
    
    func check() {
        let id = images[imageIndex].id
        if DataManager.shared.favouriteImagesIds.contains(id) {
            markAsFavourite()
        } else {
            removeFavouriteMark()
        }
    }
    
    func heartButtonPressed() {
        let id = images[imageIndex].id
        if DataManager.shared.favouriteImagesIds.contains(id) {
            DataManager.shared.removeFromFavourite(id)
            removeFavouriteMark()
        } else {
            DataManager.shared.addToFavourite(id)
            markAsFavourite()
        }
    }
}
