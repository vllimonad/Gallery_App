//
//  DataManager.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 04/12/2024.
//

import Foundation
final class DataManager {
    private let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("favourite.txt")
    
    func fetchFavouriteImagesIds() -> [String] {
        guard let data = try? Data(contentsOf: url) else { return [] }
        guard let fetchedIds = try? JSONDecoder().decode([String].self, from: data) else { return [] }
        return fetchedIds
    }
    
    func saveFavouriteImagesIds(_ favouriteImagesIds: [String]) {
        guard let data = try? JSONEncoder().encode(favouriteImagesIds) else { return }
        try? data.write(to: url)
    }
}
