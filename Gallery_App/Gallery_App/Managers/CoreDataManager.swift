//
//  CoreDataManager.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 21/01/2025.
//

import Foundation
import CoreData
import UIKit

protocol CoreDataManagerProtocol {
    func fetchImages() -> [ImageEntity]
    func saveImage(_ imageDTO: FetchedImage)
    func deleteImage(_ id: String)
}

final class CoreDataManager {
    private lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
}

extension CoreDataManager: CoreDataManagerProtocol {
    func deleteImage(_ id: String) {
    }
    
    func saveImage(_ image: FetchedImage) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Image", in: context) else { return }
        let imageEntity = ImageEntity(entity: entity, insertInto: context)
        imageEntity.id = image.id
        imageEntity.title = image.alt_description
        imageEntity.regularUrl = image.urls.regular
        imageEntity.thumbUrl = image.urls.thumb
        
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func fetchImages() -> [ImageEntity] {
        var images = [ImageEntity]()
        let request = ImageEntity.fetchRequest()
        
        do {
            images = try context.fetch(request)
        } catch let error {
            print(error.localizedDescription)
        }
        
        return images
    }
}
