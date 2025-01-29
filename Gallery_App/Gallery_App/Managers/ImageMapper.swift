//
//  ImageMapper.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 28/01/2025.
//

import Foundation

final class ImageMapper {
    func map(_ data: Data) -> [Image] {
        guard let fetchedImages = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else { return [] }
        var images = [Image]()
        for fetchedImage in fetchedImages {
            let id = fetchedImage["id"] as! String
            let title = fetchedImage["title"] as! String
            let regularUrl = fetchedImage["regularUrl"] as! String
            let thumbUrl = fetchedImage["thumbUrl"] as! String
            let image = Image(id: id, title: title, regularUrl: regularUrl, thumbUrl: thumbUrl)
            images.append(image)
        }
        return images
    }
}

