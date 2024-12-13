//
//  ImageCollectionViewModel.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 28/11/2024.
//

import Foundation
final class ImageCollectionViewModel {
    private var allImages = [Image]()
    private var favouriteImages = [Image]()
    private var showOnlyFavourite = false
    private var requestManager: RequestManager
    private var dataManager: DataManager
    weak var delegate: ImageCollectionViewModelDelegate?
    
    init() {
        requestManager = RequestManager()
        dataManager = DataManager()
        favouriteImages = dataManager.fetchFavouriteImages()
    }
    
    private func getItemsIndexPathArray() -> [IndexPath] {
        var indexPaths = [IndexPath]()
        for index in (allImages.count-30)...(allImages.count-1) {
            indexPaths.append(IndexPath(item: index, section: 0))
        }
        return indexPaths
    }
}

extension ImageCollectionViewModel: ImageCollectionViewModelProtocol {
    var showFavouriteImages: Bool {
        get {
            showOnlyFavourite
        }
        set {
            showOnlyFavourite = newValue
        }
    }
    
    func fetchImages() {
        let baseUrl = "https://api.unsplash.com/photos"
        let pageParameter = "page=\(requestManager.getPage())"
        let perPageParameter = "per_page=\(requestManager.getPerPage())"
        let clientIdParameter = "client_id=\(requestManager.getClientId())"
        let urlString = "\(baseUrl)?\(pageParameter)&\(perPageParameter)&\(clientIdParameter)"
        NetworkManager().fetchData(with: urlString) { result in
            switch result {
            case .success(let data):
                guard let data = try? JSONDecoder().decode([Image].self, from: data) else { return }
                DispatchQueue.main.async {
                    self.allImages.append(contentsOf: data)
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
        guard indexPath.item >= allImages.count - 4  else { return }
        requestManager.nextPage()
        fetchImages()
    }
    
    func reloadData() {
        allImages = []
        requestManager.resetPage()
        fetchImages()
    }
    
    func getImages() -> [Image] {
        showOnlyFavourite ? favouriteImages : allImages
    }
    
    func isImageFavourite(_ indexPath: IndexPath) -> Bool {
        showOnlyFavourite ? false : favouriteImages.contains(where: { $0.id == allImages[indexPath.item].id })
    }
    
    func updateFavouriteImages() {
        favouriteImages = dataManager.fetchFavouriteImages()
    }
}

protocol ImageCollectionViewModelProtocol {
    var showFavouriteImages: Bool { get set }
    func fetchImages()
    func reloadData()
    func loadNextPage(_ indexPath: IndexPath)
    func isImageFavourite(_ indexPath: IndexPath) -> Bool
    func getImages() -> [Image]
    func updateFavouriteImages()
}
