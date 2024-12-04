//
//  ImageCollectionViewModel.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 28/11/2024.
//

import Foundation
class ImageCollectionViewModel {
    var images = [ImageInfo]()
    var updateView: () -> () = {}
    private let urlString = "https://api.unsplash.com/photos?page=1&per_page=30&client_id=1NCPQEX5juLF1PEgNi2TITI-XXtZVnEpKyqGCgLU1KA"
    
    func fetchImages() {
        NetworkService.shared.fetchData(with: urlString) { result in
            switch result {
            case .success(let data):
                guard let data = try? JSONDecoder().decode([ImageInfo].self, from: data) else { return }
                DispatchQueue.main.async {
                    self.images = data
                    self.updateView()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func isImageFavourite(_ indexPath: IndexPath) -> Bool {
        DataManager.shared.favouriteImagesIds.contains(images[indexPath.item].id)
    }
}
