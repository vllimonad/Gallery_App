//
//  ImageCollectionViewModel.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 28/11/2024.
//

import Foundation
class ImageCollectionViewModel {
    var images = [ImageInfo]()
    var insertItems: (([IndexPath]) -> ())!
    
    var page = 1
    let imagesPerPage = 30
    let clientId = "1NCPQEX5juLF1PEgNi2TITI-XXtZVnEpKyqGCgLU1KA"
    
    func fetchImages() {
        NetworkService.shared.fetchData(with: "https://api.unsplash.com/photos?page=\(page)&per_page=\(imagesPerPage)&client_id=\(clientId)") { result in
            switch result {
            case .success(let data):
                guard let data = try? JSONDecoder().decode([ImageInfo].self, from: data) else { return }
                DispatchQueue.main.async {
                    self.images.append(contentsOf: data)
                    self.insertItems(self.getItemsIndexPathArray())
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func isImageFavourite(_ indexPath: IndexPath) -> Bool {
        DataManager.shared.favouriteImagesIds.contains(images[indexPath.item].id)
    }
    
    func getItemsIndexPathArray() -> [IndexPath] {
        var indexPaths = [IndexPath]()
        for index in (images.count-30)...(images.count-1) {
            indexPaths.append(IndexPath(item: index, section: 0))
        }
        return indexPaths
    }
    
    func loadNextPage(_ indexPath: IndexPath) {
        if indexPath.item == images.count - 1 {
            page += 1
            fetchImages()
        }
    }
}
