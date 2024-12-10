//
//  DataManager.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 04/12/2024.
//

import Foundation
final class DataManager {
    static let shared = DataManager()
    var favouriteImagesIds = [String]()
    private let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("favourite.txt")
    
    private init() {
        fetchFavouriteImagesIds()
    }
    
    func fetchFavouriteImagesIds() {
        guard let data = try? Data(contentsOf: url) else { return }
        guard let fetchedIds = try? JSONDecoder().decode([String].self, from: data) else { return }
        favouriteImagesIds = fetchedIds
    }
    
    func addToFavourite(_ id: String) {
        favouriteImagesIds.append(id)
        saveFavouriteImagesIds()
    }
    
    func removeFromFavourite(_ id: String) {
        guard let index = favouriteImagesIds.firstIndex(of: id) else { return }
        favouriteImagesIds.remove(at: index)
        saveFavouriteImagesIds()
    }
    
    func saveFavouriteImagesIds() {
        guard let data = try? JSONEncoder().encode(favouriteImagesIds) else { return }
        try? data.write(to: url)
    }
}
