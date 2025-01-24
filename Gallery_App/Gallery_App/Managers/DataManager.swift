//
//  DataManager.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 04/12/2024.
//

import Foundation

protocol DataManagerProtocol {
    func fetchFavouriteImages() -> [FetchedImage]
    func saveFavouriteImages(_ favouriteImages: [FetchedImage])
}

final class DataManager {
    private let fileName = "favouriteImages.txt"
    private var url: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(fileName)
    }
}

extension DataManager: DataManagerProtocol {
    func fetchFavouriteImages() -> [FetchedImage] {
        guard let data = try? Data(contentsOf: url) else { return [] }
        guard let favouriteImages = try? JSONDecoder().decode([FetchedImage].self, from: data) else { return [] }
        return favouriteImages
    }
    
    func saveFavouriteImages(_ favouriteImages: [FetchedImage]) {
        guard let data = try? JSONEncoder().encode(favouriteImages) else { return }
        try? data.write(to: url)
    }
}
