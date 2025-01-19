//
//  ImageDetailsViewModelTests.swift
//  Gallery_AppTests
//
//  Created by Vlad Klunduk on 13/01/2025.
//

import XCTest
@testable import Gallery_App

final class ImageDetailsViewModelTests: XCTestCase {

    var sut: ImageDetailsViewModel!
    var dataManager: DataManagerProtocol!
    var delegate: ImageDetailsViewModelDelegate!
    
    override func setUp() {
        super.setUp()
        var urlType = URLType(regular: "link", thumb: "link")
        var image = Image(id: "0", alt_description: "image 1", urls: urlType)
        dataManager = SpyDataManager()
        sut = ImageDetailsViewModel(images: [image],
                                    imageIndex: 0,
                                    dataManager: dataManager)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
}


final class SpyDataManager {
    var fetchedImages: [Image]?
    var savedImages: [Image]?
}

extension SpyDataManager: DataManagerProtocol {
    func fetchFavouriteImages() -> [Image] {
        fetchedImages ?? []
    }
    
    func saveFavouriteImages(_ favouriteImages: [Image]) {
        savedImages = favouriteImages
    }
}


final class SpyImageDetailsViewModelDelegate {
    var isFavourite: Bool?
    var isAlertShown: Bool?
}

extension SpyImageDetailsViewModelDelegate: ImageDetailsViewModelDelegate {
    func updateImageDetails(with imageData: Data, and imageDescription: String) {
        
    }
    
    func markAsFavourite() {
        isFavourite = true
    }
    
    func removeFavouriteMark() {
        isFavourite = false
    }
    
    func showAlert(_ error: any Error) {
        isAlertShown = true
    }
}
