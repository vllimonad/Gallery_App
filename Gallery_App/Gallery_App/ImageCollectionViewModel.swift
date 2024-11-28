//
//  ImageCollectionViewModel.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 28/11/2024.
//

import Foundation
class ImageCollectionViewModel {
    var images = [ImageInfo]()
    var updateView: () -> () = {}
    
    func fetchImages() {
        NetworkService.shared.fetchImages { result in
            switch result {
            case .success(let data):
                guard let data = try? JSONDecoder().decode([ImageInfo].self, from: data) else { return }
                DispatchQueue.main.async {
                    self.images = data
                    self.updateView()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
