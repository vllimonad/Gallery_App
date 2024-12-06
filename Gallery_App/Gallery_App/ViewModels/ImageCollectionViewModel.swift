//
//  ImageCollectionViewModel.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 28/11/2024.
//

import Foundation
class ImageCollectionViewModel {
    private var images = [Image]()
    weak var delegate: ImageCollectionViewModelDelegate!
    
    var page = 1
    let imagesPerPage = 30
    let clientId = "1NCPQEX5juLF1PEgNi2TITI-XXtZVnEpKyqGCgLU1KA"
    
    private func getItemsIndexPathArray() -> [IndexPath] {
        var indexPaths = [IndexPath]()
        for index in (images.count-30)...(images.count-1) {
            indexPaths.append(IndexPath(item: index, section: 0))
        }
        return indexPaths
    }
}

extension ImageCollectionViewModel: ImageCollectionViewModelProtocol {
    func fetchImages() {
        let urlString = "https://api.unsplash.com/photos?page=\(page)&per_page=\(imagesPerPage)&client_id=\(clientId)"
        NetworkManager.shared.fetchData(with: urlString) { result in
            switch result {
            case .success(let data):
                guard let data = try? JSONDecoder().decode([Image].self, from: data) else { return }
                DispatchQueue.main.async {
                    self.images.append(contentsOf: data)
                    self.delegate.insertItems(self.getItemsIndexPathArray())
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate.showAlert(error)
                }
            }
        }
    }
    
    func loadNextPage(_ indexPath: IndexPath) {
        if indexPath.item >= images.count - 4 {
            page += 1
            fetchImages()
        }
    }
    
    func reloadView() {
        images = []
        page = 1
        fetchImages()
    }
    
    func getImages() -> [Image] {
        images
    }
    
    func getImagesCount() -> Int {
        images.count
    }
    
    func getImageUrl(_ indexPath: IndexPath) -> String {
        images[indexPath.item].urls.thumb
    }
    
    func isImageFavourite(_ indexPath: IndexPath) -> Bool {
        DataManager.shared.favouriteImagesIds.contains(images[indexPath.item].id)
    }
}

protocol ImageCollectionViewModelProtocol {
    func fetchImages()
    func reloadView()
    func loadNextPage(_ indexPath: IndexPath)
    func isImageFavourite(_ indexPath: IndexPath) -> Bool
    func getImages() -> [Image]
    func getImagesCount() -> Int
    func getImageUrl(_ indexPath: IndexPath) -> String
}
