//
//  ImageMapper.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 28/01/2025.
//

import Foundation

protocol Mappable {
    func map(_ data: Data) -> [Image]
}

final class ImageMapper {}

extension ImageMapper: Mappable {
    func map(_ data: Data) -> [Image] {
        guard let fetchedImages = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else { return [] }
        var images = [Image]()
        for fetchedImage in fetchedImages {
            let id = fetchedImage["id"] as! String
            let title = fetchedImage["alt_description"] as? String ?? ""
            let urls = fetchedImage["urls"] as! [String: String]
            let regularUrl = urls["regular"]!
            let thumbUrl = urls["thumb"]!
            let image = Image(id: id, title: title, regularUrl: regularUrl, thumbUrl: thumbUrl)
            images.append(image)
        }
        return images
    }
}

