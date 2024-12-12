//
//  DataManager.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 04/12/2024.
//

import Foundation
final class DataManager {
    private let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("favouriteImages.txt")
    
    func fetchFavouriteImages() -> [Image] {
        guard let data = try? Data(contentsOf: url) else { return [] }
        guard let favouriteImages = try? JSONDecoder().decode([Image].self, from: data) else { return [] }
        return favouriteImages
    }
    
    func saveFavouriteImages(_ favouriteImages: [Image]) {
        guard let data = try? JSONEncoder().encode(favouriteImages) else { return }
        try? data.write(to: url)
    }
}
