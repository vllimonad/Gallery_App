//
//  ImageDetailsViewModel.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 28/11/2024.
//

import Foundation
class ImageDetailsViewModel {
    var imageData: Data!
    var updateView: () -> () = {}
    
    func fetchImage(_ imageUrlString: String) {
        NetworkService.shared.fetchData(with: imageUrlString) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.imageData = data
                    self.updateView()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
