//
//  ImageCollectionViewModel.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 28/11/2024.
//

import Foundation
final class ImageCollectionViewModel {
    private var images = [Image]()
    private var requestManager: RequestManager
    weak var delegate: ImageCollectionViewModelDelegate?
    
    init() {
        requestManager = RequestManager()
    }
    
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
        let page = requestManager.getPage()
        let perPage = requestManager.getPerPage()
        let clientId = requestManager.getClientId()
        let urlString = "https://api.unsplash.com/photos?page=\(page)&per_page=\(perPage)&client_id=\(clientId)"
        NetworkManager.shared.fetchData(with: urlString) { result in
            switch result {
            case .success(let data):
                guard let data = try? JSONDecoder().decode([Image].self, from: data) else { return }
                DispatchQueue.main.async {
                    self.images.append(contentsOf: data)
                    self.delegate?.insertItems(self.getItemsIndexPathArray())
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.showAlert(error)
                }
            }
        }
    }
    
    func loadNextPage(_ indexPath: IndexPath) {
        if indexPath.item >= images.count - 4 {
            requestManager.nextPage()
            fetchImages()
        }
    }
    
    func reloadView() {
        images = []
        requestManager.resetPage()
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
