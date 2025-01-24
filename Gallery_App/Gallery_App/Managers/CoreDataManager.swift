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
    func fetchImages() -> [Image]
    func saveImage(_ imageDTO: FetchedImage)
    func deleteImage(_ id: String)
}

final class CoreDataManager {
    private lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
}

extension CoreDataManager: CoreDataManagerProtocol {
    func deleteImage(_ id: String) {
        
    }
    
    func saveImage(_ imageDTO: FetchedImage) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Image", in: context) else { return }
        let image = Image(entity: entity, insertInto: context)
        image.id = imageDTO.id
        image.name = imageDTO.alt_description
        image.regularURL = imageDTO.urls.regular
        image.thumbURL = imageDTO.urls.thumb
        
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func fetchImages() -> [Image] {
        var images = [Image]()
        let request = Image.fetchRequest()
        
        do {
            images = try context.fetch(request)
        } catch let error {
            print(error.localizedDescription)
        }
        
        return images
    }
}
