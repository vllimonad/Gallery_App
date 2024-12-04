//
//  ImageInfo.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 28/11/2024.
//

import Foundation
struct ImageInfo: Codable {
    var id: String
    var alt_description: String
    var urls: URLType
}

struct URLType: Codable {
    var regular: String
    var thumb: String
}
