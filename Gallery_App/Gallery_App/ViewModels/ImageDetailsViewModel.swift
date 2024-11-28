//
//  ImageDetailsViewModel.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 28/11/2024.
//

import Foundation
class ImageDetailsViewModel {
    var imageUrlString: String
    var imageData: Data!
    var updateView: () -> () = {}
    
    init(_ imageUrlString: String) {
        self.imageUrlString = imageUrlString
    }
    
    func fetchImage() {
        
    }
}
