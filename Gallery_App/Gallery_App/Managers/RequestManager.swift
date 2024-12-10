//
//  RequestManager.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 06/12/2024.
//

import Foundation
final class RequestManager {
    private var page = 1
    private let perPage = 30
    private let clientId = "1NCPQEX5juLF1PEgNi2TITI-XXtZVnEpKyqGCgLU1KA"
    
    func resetPage() {
        page = 1
    }
    
    func nextPage() {
        page += 1
    }
    
    func getPage() -> Int {
        page
    }
    
    func getPerPage() -> Int {
        perPage
    }
    
    func getClientId() -> String {
        clientId
    }
}
