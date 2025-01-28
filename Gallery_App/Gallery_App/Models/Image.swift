//
//  Image.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 28/01/2025.
//

import Foundation

struct Image {
    var id: String
    var title: String
    var regularUrl: String
    var thumbUrl: String
}

extension Image {
    init(_ entity: ImageEntity) {
        self.id = entity.id!
        self.title = entity.title!
        self.regularUrl = entity.regularUrl!
        self.thumbUrl = entity.thumbUrl!
    }
}
