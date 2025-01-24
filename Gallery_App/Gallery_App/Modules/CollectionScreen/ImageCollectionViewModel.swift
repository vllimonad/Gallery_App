//
//  ImageCollectionViewModel.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 28/11/2024.
//

import Foundation

protocol ImageCollectionViewModelProtocol {
    var showFavouriteImages: Bool { get set }
    func fetchImages()
    func reloadData()
    func loadNextPage(_ indexPath: IndexPath)
    func isImageFavourite(_ indexPath: IndexPath) -> Bool
    func getImages() -> [FetchedImage]
    func updateFavouriteImages()
    func getItemsIndexPathArray() -> [IndexPath]
}

final class ImageCollectionViewModel {
    private var allImages = [FetchedImage]()
    private var favouriteImages = [FetchedImage]()
    private var showOnlyFavourite = false
    private var page = 1
    private let perPage = 30
    private let clientId = "1NCPQEX5juLF1PEgNi2TITI-XXtZVnEpKyqGCgLU1KA"
    
    private var dataManager: DataManagerProtocol
    private var networkManager: NetworkManagerProtocol
    weak var delegate: ImageCollectionViewModelDelegate?
    
    init(dataManager: DataManagerProtocol = DataManager(), networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.dataManager = dataManager
        self.networkManager = networkManager
        favouriteImages = dataManager.fetchFavouriteImages()
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
        let pageParameter = "page=\(page)"
        let perPageParameter = "per_page=\(perPage)"
        let clientIdParameter = "client_id=\(clientId)"
        let urlString = "\(baseUrl)?\(pageParameter)&\(perPageParameter)&\(clientIdParameter)"
        
        networkManager.fetchData(with: urlString) { result in
            switch result {
            case .success(let data):
                guard let data = try? JSONDecoder().decode([FetchedImage].self, from: data) else { return }
                DispatchQueue.main.async {
                    self.allImages.append(contentsOf: data)
                    self.delegate?.insertItems()
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
        page += 1
    }
    
    func reloadData() {
        allImages = []
        page = 1
    }
    
    func getImages() -> [FetchedImage] {
        showOnlyFavourite ? favouriteImages : allImages
    }
    
    func isImageFavourite(_ indexPath: IndexPath) -> Bool {
        showOnlyFavourite ? false : favouriteImages.contains(where: { $0.id == allImages[indexPath.item].id })
    }
    
    func updateFavouriteImages() {
        favouriteImages = dataManager.fetchFavouriteImages()
    }
    
    func getItemsIndexPathArray() -> [IndexPath] {
        var indexPaths = [IndexPath]()
        for index in (allImages.count-30)...(allImages.count-1) {
            indexPaths.append(IndexPath(item: index, section: 0))
        }
        return indexPaths
    }
}
