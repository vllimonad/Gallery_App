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
    func insertImage(_ image: Image)
    func deleteImage(_ image: Image)
    func fetchImages() -> [Image]
    func fetchImageById(_ id: String) -> ImageEntity?
}

final class CoreDataManager {
    private lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private func saveContext() {
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

extension CoreDataManager: CoreDataManagerProtocol {
    func insertImage(_ image: Image){
        guard let entity = NSEntityDescription.entity(forEntityName: "ImageEntity", in: context) else { return }
        let imageEntity = ImageEntity(entity: entity, insertInto: context)
        imageEntity.id = image.id
        imageEntity.title = image.title
        imageEntity.regularUrl = image.regularUrl
        imageEntity.thumbUrl = image.thumbUrl
        self.saveContext()
    }
    
    func deleteImage(_ image: Image) {
        guard let imageEntity = fetchImageById(image.id) else { return }
        context.delete(imageEntity)
        saveContext()
    }
    
    func fetchImages() -> [Image] {
        var imageEntities = [ImageEntity]()
        let request = ImageEntity.fetchRequest()
        do {
            imageEntities = try context.fetch(request)
        } catch let error {
            print(error.localizedDescription)
        }
        
        var images = [Image]()
        for entity in imageEntities {
            images.append(Image(entity))
        }
        
        return images
    }
    
    func fetchImageById(_ id: String) -> ImageEntity? {
        let request = ImageEntity.fetchRequest()
        let predicate = NSPredicate(format: "id==%@", id)
        request.predicate = predicate
        return try? context.fetch(request).first
    }
}
