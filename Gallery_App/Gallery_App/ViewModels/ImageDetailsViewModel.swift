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
    
    func fetchImage(_ imageUrlString: String) {
        NetworkService.shared.fetchData(with: imageUrlString) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.imageData = data
                    self.updateImage()
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
}
