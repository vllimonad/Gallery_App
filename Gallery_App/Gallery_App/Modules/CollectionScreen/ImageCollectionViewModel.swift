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
    func reloadImages()
    func loadNextImages(_ indexPath: IndexPath)
    func isImageFavourite(_ indexPath: IndexPath) -> Bool
    func getImages() -> [Image]
    func updateFavouriteImages()
    func getItemsIndexPathArray() -> [IndexPath]
}

final class ImageCollectionViewModel {
    private var images = [Image]()
    private var favouriteImages = [Image]()
    private var showOnlyFavouriteImages = false
    
    private var page = 1 {
        didSet {
            fetchImages()
        }
    }
    private let perPage = 30
    private let clientId = "1NCPQEX5juLF1PEgNi2TITI-XXtZVnEpKyqGCgLU1KA"
    
    private var mapper: ImageMapper
    private var dataManager: CoreDataManagerProtocol
    private var networkManager: NetworkManagerProtocol
    weak var delegate: ImageCollectionViewModelDelegate?
    
    init(mapper: ImageMapper = ImageMapper(), dataManager: CoreDataManagerProtocol = CoreDataManager(), networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.mapper = mapper
        self.dataManager = dataManager
        self.networkManager = networkManager
        favouriteImages = dataManager.fetchImages()
    }
}

extension ImageCollectionViewModel: ImageCollectionViewModelProtocol {
    var showFavouriteImages: Bool {
        get {
            showOnlyFavouriteImages
        }
        set {
            showOnlyFavouriteImages = newValue
        }
    }
    
    func fetchImages() {
        let baseUrl = "https://api.unsplash.com/photos"
        let pageParameter = "page=\(page)"
        let perPageParameter = "per_page=\(perPage)"
        let clientIdParameter = "client_id=\(clientId)"
        let urlString = "\(baseUrl)?\(pageParameter)&\(perPageParameter)&\(clientIdParameter)"
        
        networkManager.fetchData(with: urlString) { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async { [weak self] in
                    guard let newImages = self?.mapper.map(data) else { return }
                    self?.images.append(contentsOf: newImages)
                    self?.delegate?.insertItems()
                }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.showAlert(error)
                }
            }
        }
    }
    
    func loadNextImages(_ indexPath: IndexPath) {
        guard !showOnlyFavouriteImages else { return }
        guard indexPath.item + 4 >= images.count else { return }
        page += 1
    }
    
    func reloadImages() {
        images = []
        page = 1
    }
    
    func getImages() -> [Image] {
        showOnlyFavouriteImages ? favouriteImages : images
    }
    
    func isImageFavourite(_ indexPath: IndexPath) -> Bool {
        showOnlyFavouriteImages ? false : favouriteImages.contains(where: { $0.id == images[indexPath.item].id })
    }
    
    func updateFavouriteImages() {
        favouriteImages = dataManager.fetchImages()
    }
    
    func getItemsIndexPathArray() -> [IndexPath] {
        var indexPaths = [IndexPath]()
        for index in (images.count-30)...(images.count-1) {
            indexPaths.append(IndexPath(item: index, section: 0))
        }
        return indexPaths
    }
}
